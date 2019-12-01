pragma solidity ^0.5.0;

import "./CowriRoot.sol";

contract LiquidityMembrane is CowriRoot {

    event addLiquidity(
        address indexed provider,
        address indexed shell,
        address[] indexed tokens,
        uint256[] amounts
    );

    event removeLiquidity(
        address indexed provider,
        address indexed shell,
        address[] indexed tokens,
        uint256[] amounts
    );

    function calculateGeoometricMeansWithFloats (
        address _shell,
        uint256[] memory amounts
    ) public returns (uint256, uint256) {

        address[] memory tokens = CowriShell(_shell).getTokens();

        bytes16 prevProduct = 0x3fff0000000000000000000000000000;
        bytes16 nextProduct = 0x3fff0000000000000000000000000000;

        for (uint i = 0; i < tokens.length; i++) {
            bytes16 balance = fromUInt(shellBalances[makeKey(_shell, tokens[i])]);
            prevProduct = float_mul(prevProduct, balance);
            if (amounts[i] > 0) balance = float_add(balance, fromUInt(amounts[i]));
            nextProduct = float_mul(nextProduct, balance);
        }

        return (
            toUInt(calculateRootFloat(prevProduct, tokens.length)),
            toUInt(calculateRootFloat(nextProduct, tokens.length))
        );
    }

    function calculateGeometricMeansWithWads (
        address _shell,
        uint256[] memory amounts,
        bool deposit
    ) public returns (uint256, uint256) {

        address[] memory tokens = CowriShell(_shell).getTokens();
        uint256 prevProduct = WAD;
        uint256 nextProduct = WAD;
        uint256 prevRoot = WAD;
        uint256 nextRoot = WAD;

        for (uint8 i = 0; i < tokens.length; i++) {
            uint256 balance = shellBalances[makeKey(_shell, tokens[i])];
            uint256 x;
            uint256 y;

            // execute and check for safe fixed point multiplication
            if ((x = prevProduct * balance) / balance == prevProduct &&
                (y = x + WAD / 2) >= x ) {
                    prevProduct = y / WAD;
            } else {
                // emit log_named_uint("overflow prev", i);
                uint256 prevRootPrime = calculateRootWad(prevProduct, tokens.length);
                prevRoot = wmul(prevRoot, prevRootPrime);
                prevProduct = balance;
            }

            bool addsubd = deposit
                ? (balance = balance + amounts[i]) >= balance
                : (balance = balance - amounts[i]) <= balance;

            // execute and check for safe addition
            if (addsubd) {
                // execute and check for safe fixed point multiplication
                if ((x = nextProduct * balance) / balance == nextProduct &&
                    (y = x + WAD / 2) >= x) {
                    nextProduct = y / WAD;
                } else {
                    // emit log_named_uint("overflow next", i);
                    uint256 nextRootPrime = calculateRootWad(nextProduct, tokens.length);
                    nextRoot = wmul(nextRoot, nextRootPrime);
                    nextProduct = balance;
                }
            } else require(false, "contributed liquidity is too large, triggers integer overflow");

            if (i == tokens.length - 1) {
                uint256 prevRootPrime = calculateRootWad(prevProduct, tokens.length);
                uint256 nextRootPrime = calculateRootWad(nextProduct, tokens.length);
                prevRoot = wmul(prevRoot, prevRootPrime);
                nextRoot = wmul(nextRoot, nextRootPrime);
            }
        }

        return (prevRoot, nextRoot);

    }

    function calculateRootWad (
        uint256 base,
        uint256 root
    ) internal returns (uint256) {
        uint256 guess = toUInt(fast_aprx_root_wad(fromUInt(base / WAD), root));

        return refine_root_wad(
            guess,
            base,
            root,
            10
        );
    }

    function calculateRootFloat (
        bytes16 base,
        uint256 root
    ) internal returns (bytes16) {

        bytes16 guess = fast_aprx_root_float(base, root);
        return refine_root_float(guess, base, root, 5);

    }

    event log_named_bytes32(bytes32 key, bytes32 val);

    function depositSelectiveLiquidity (
        address _shell,
        uint256[] calldata _amounts
    ) external returns (uint256) {

        CowriShell shell = CowriShell(_shell);
        (uint256 previousInvariant, uint256 nextInvariant) = calculateGeometricMeansWithWads(_shell, _amounts, true);

        uint256 outstanding = shell.totalSupply();
        address[] memory tokens = shell.getTokens();

        for (uint i = 0; i < tokens.length; i++) {
            if (_amounts[i] > 0) {
                shellBalances[makeKey(_shell, tokens[i])] = add(
                    shellBalances[makeKey(_shell, tokens[i])],
                    _amounts[i]
                );
                adjustedTransferFrom(ERC20Token(tokens[i]), msg.sender, _amounts[i]);
            }
        }

        uint256 minted = wdiv(
            wmul(sub(nextInvariant, previousInvariant), outstanding),
            previousInvariant
        );

        shell.mint(msg.sender, minted);
        return minted;

    }

    function withdrawSelectiveLiquidity (
        address _shell,
        uint256[] calldata _amounts
    ) external returns (uint256) {

        CowriShell shell = CowriShell(_shell);
        (uint256 previousInvariant, uint256 nextInvariant) = calculateGeometricMeansWithWads(_shell, _amounts, false);

        uint256 outstanding = shell.totalSupply();
        address[] memory tokens = shell.getTokens();

        for (uint i = 0; i < tokens.length; i++) {
            if (_amounts[i] > 0) {
                shellBalances[makeKey(_shell, tokens[i])] = sub(
                    shellBalances[makeKey(_shell, tokens[i])],
                    _amounts[i]
                );
                adjustedTransfer(ERC20Token(tokens[i]), msg.sender, _amounts[i]);
            }
        }

        uint256  burned = wdiv(
            wmul(sub(previousInvariant, nextInvariant), outstanding),
            previousInvariant
        );

        shell.testBurn(msg.sender, burned);

        return burned;

    }

    function depositLiquidity(
        address _shell,
        uint256 amount,
        uint256 deadline
    ) external returns (uint256) {
        // emit log_named_uint("deadline", deadline);
        require(block.timestamp <= deadline, "must be processed before deadline");
        require(amount > 0, "amount must be above 0");

        CowriShell shell = CowriShell(_shell);
        uint256 totalCapital = getTotalCapital(_shell);
        uint256 totalSupply = shell.totalSupply();
        uint256 liqTokensMinted;
        uint256 adjustedAmount;
        address[] memory tokens = shell.getTokens();
        uint256[] memory liquidityAdded = new uint256[](tokens.length);

        if (totalSupply == 0) {

            liqTokensMinted = amount;
            adjustedAmount = wdiv(amount, tokens.length * WAD);

        } else liqTokensMinted = wdiv(wmul(totalSupply, amount), totalCapital);

        for(uint i = 0; i < tokens.length; i++) {

            uint256 balanceKey = makeKey(_shell, address(tokens[i]));
            uint256 currentBalance = shellBalances[balanceKey];
            uint256 relativeAmount = totalSupply != 0
                ? wdiv(wmul(amount, currentBalance), totalCapital)
                : adjustedAmount;

            liquidityAdded[i] = relativeAmount;

            adjustedTransferFrom(
                ERC20Token(tokens[i]),
                msg.sender,
                relativeAmount
            );

            shellBalances[balanceKey] = add(
                currentBalance,
                relativeAmount
            );

        }

        shell.mint(msg.sender, liqTokensMinted);

        emit addLiquidity(msg.sender, _shell, tokens, liquidityAdded);

        return liqTokensMinted;
    }

    event log_uint(bytes32 key, uint256 val);

    function withdrawLiquidity (
        address _shell,
        uint256 liquidityToBurn,
        uint256[] calldata limits,
        uint256 deadline
    ) external returns (uint256[] memory) {
        require(block.timestamp <= deadline, "must be processed before deadline");

        CowriShell shell = CowriShell(_shell);
        require(shell.balanceOf(msg.sender) >= liquidityToBurn, "must only burn tokens you have");

        uint256 totalCapital = getTotalCapital(_shell);
        uint256 capitalWithdrawn = wdiv(
            wmul(totalCapital, liquidityToBurn),
            shell.totalSupply()
        );

        address[] memory tokens = shell.getTokens();
        uint256[] memory amountsWithdrawn = new uint256[](tokens.length);
        for(uint i = 0; i < tokens.length; i++) {

            uint256 balanceKey = makeKey(_shell, tokens[i]);

            uint amount = wdiv(
                wmul(capitalWithdrawn, shellBalances[balanceKey]),
                totalCapital
            );

            require(limits[i] <= amount, "withdrawn amount must be equal to or above minimum amount");

            amountsWithdrawn[i] = adjustedTransfer(
                ERC20Token(tokens[i]),
                msg.sender,
                amount
            );

            shellBalances[balanceKey] = sub(
                shellBalances[balanceKey],
                amount
            );

        }

        shell.testBurn(msg.sender, liquidityToBurn);

        emit removeLiquidity(msg.sender, _shell, tokens, amountsWithdrawn);

        return amountsWithdrawn;
    }


    function getTotalCapital(
        address shell
    ) public view returns (uint totalCapital) {
        address[] memory tokens = CowriShell(shell).getTokens();
        for (uint i = 0; i < tokens.length; i++) {
            uint256 balanceKey = makeKey(shell, tokens[i]);
            totalCapital = add(totalCapital, shellBalances[balanceKey]);
         }
        return totalCapital;
    }

}