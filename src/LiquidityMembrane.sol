pragma solidity ^0.5.0;

import "./LoihiRoot.sol";

contract LiquidityMembrane is LoihiRoot {

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

    function getOverlap (address[] memory left, address[] memory right) private returns (uint256) {
        uint256 overlap;
        for (uint i = 0; i < left.length; i++) {
            for (uint j = 0; j < right.length; j++) {
                if (left[i] == right[j]) {
                    overlap++;
                    break;
                }
            }
        }
        return overlap;
    }

    function interShellTransfer (address originShell, address targetShell, uint256 amount) public returns (uint256) {

        address[] memory originTokens = CowriShell(originShell).getTokens();
        address[] memory targetTokens = CowriShell(targetShell).getTokens();
        uint256[] memory targetHaltStops = new uint256[](targetTokens.length * 2);
        uint256[] memory originHaltStops = new uint256[](originTokens.length * 2);

        uint256 factor = wdiv(
            sub(CowriShell(originShell).totalSupply(), amount),
            CowriShell(originShell).totalSupply()
        );
        factor = wpow(factor, originTokens.length);
        factor = calculateRoot(factor, getOverlap(originTokens, targetTokens));

        // get the origin withdrawal amount and the target deposit amount
        // while setting the arrays for halt stop check
        for (uint j = 0; j < originTokens.length; j++) {
            for (uint i = 0; i < targetTokens.length; i++) {
                if (targetTokens[i] == originTokens[j]) {
                    uint256 balance = shellBalances[makeKey(originShell, originTokens[j])];
                    originHaltStops[j*2+1] = wmul(factor, balance);
                    shellBalances[makeKey(originShell, originTokens[j])] = originHaltStops[j*2+1];
                    originHaltStops[j*2] = sub(balance, originHaltStops[j*2+1]);
                    targetHaltStops[i*2] = originHaltStops[j*2];
                }
            }
        }

        // selectively deposit into target shell and set the remaining info
        // for the target deposit halt stop check
        for (uint i = 0; i < targetTokens.length; i++) {
            targetHaltStops[i*2+1] = add(shellBalances[makeKey(targetShell, targetTokens[i])], targetHaltStops[i*2]);
            shellBalances[makeKey(targetShell, targetTokens[i])] = targetHaltStops[i*2+1];
        }

        haltStopCheck(originHaltStops, false);
        haltStopCheck(targetHaltStops, true);

        uint256[] memory targetDeposits = new uint256[](targetTokens.length);
        for (uint i = 0; i < targetDeposits.length; i++) targetDeposits[i] = targetHaltStops[i*2];

        (uint256 previousTargetInvariant, uint256 nextTargetInvariant) = calculateInvariants(
            targetShell,
            targetDeposits,
            true
        );

        uint256 minted = wdiv(
            wmul(sub(nextTargetInvariant, previousTargetInvariant), CowriShell(targetShell).totalSupply()),
            previousTargetInvariant
        );

        CowriShell(targetShell).mint(msg.sender, minted);
        CowriShell(originShell).testBurn(msg.sender, amount);

        return minted;

    }

    function calculateInvariants (
        address _shell,
        uint256[] memory amounts,
        bool deposit
    ) public returns (uint256, uint256) {

        address[] memory tokens = CowriShell(_shell).getTokens();
        uint256 prevProduct = WAD;
        uint256 nextProduct = WAD;
        uint256 prevInvariant = WAD;
        uint256 nextInvariant = WAD;

        for (uint8 i = 0; i < tokens.length; i++) {
            uint256 balance = shellBalances[makeKey(_shell, tokens[i])];
            uint256 x;
            uint256 y;

            // execute and check for safe fixed point multiplication
            if ((x = prevProduct * balance) / balance == prevProduct &&
                (y = x + WAD / 2) >= x ) {
                    prevProduct = y / WAD;
            } else { // overflow, calculate root and reset product to continue
                prevInvariant = wmul(prevInvariant, calculateRoot(prevProduct, tokens.length));
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
                } else { // overflow, calculate root and reset product to continue
                    nextInvariant = wmul(nextInvariant, calculateRoot(nextProduct, tokens.length));
                    nextProduct = balance;
                }
            } else require(false, "contributed liquidity is too large, triggers integer overflow");

            if (i == tokens.length - 1) { // calculate final invariant
                prevInvariant = wmul(prevInvariant, calculateRoot(prevProduct, tokens.length));
                nextInvariant = wmul(nextInvariant, calculateRoot(nextProduct, tokens.length));
            }
        }

        return (prevInvariant, nextInvariant);

    }

    function calculateRoot (
        uint256 base,
        uint256 root
    ) public returns (uint256) {

        return refineRoot(
            base <= WAD ? base : fastAprxRoot(base / WAD, root),
            base,
            root,
            4
        );

    }

    function depositSelectiveLiquidity (
        address _shell,
        uint256[] memory _amounts
    ) public returns (uint256) {

        CowriShell shell = CowriShell(_shell);
        address[] memory tokens = shell.getTokens();
        uint256[] memory haltStopCheckPayload = new uint256[](tokens.length * 2);

        for (uint i = 0; i < tokens.length; i++) {
            if (_amounts[i] > 0) {
                haltStopCheckPayload[i*2] = _amounts[i];
                haltStopCheckPayload[i*2+1] = add(shellBalances[makeKey(_shell, tokens[i])], _amounts[i]);
                shellBalances[makeKey(_shell, tokens[i])] = haltStopCheckPayload[i*2+1];
            } else {
                haltStopCheckPayload[i*2+1] = shellBalances[makeKey(_shell, tokens[i])];
            }
        }

        haltStopCheck(haltStopCheckPayload, true);

        (uint256 previousInvariant, uint256 nextInvariant) = calculateInvariants(_shell, _amounts, true);

        uint256 outstanding = shell.totalSupply();
        uint256 minted = wdiv(
            wmul(sub(nextInvariant, previousInvariant), outstanding),
            previousInvariant
        );

        shell.mint(msg.sender, minted);

        for (uint i = 0; i < tokens.length; i++) {
            if (_amounts[i] > 0) adjustedTransferFrom(ERC20Token(tokens[i]), msg.sender, _amounts[i]);
        }

        return minted;

    }

    function haltStopCheck (
        uint256[] memory _payload,
        bool isDeposit
    ) public returns (uint256) {

        uint256 right = WAD;
        for (uint i = 0; i < _payload.length / 2; i++) right = wmul(right, _payload[i*2+1]);

        for (uint i = 0; i < _payload.length / 2; i++) {
            if (_payload[i*2] > 0) {
                if (isDeposit) {
                    uint256 left = wpow(wdiv(_payload[i*2+1], haltAlpha), _payload.length / 2 - 1);
                    require(wdiv(left, wdiv(right, _payload[i*2+1])) < WAD, "halt stop deposit");
                } else {
                    uint256 left = wpow(wmul(_payload[i*2+1], haltAlpha), _payload.length / 2 - 1);
                    require(wdiv(left, wdiv(right, _payload[i*2+1])) > WAD, "halt stop withdraw");
                }
            }
        }

    }

    function withdrawSelectiveLiquidity (
        address _shell,
        uint256[] memory _amounts
    ) public returns (uint256) {

        CowriShell shell = CowriShell(_shell);
        address[] memory tokens = shell.getTokens();
        uint256[] memory haltStopCheckPayload = new uint256[](tokens.length * 2);

        for (uint i = 0; i < tokens.length; i++) {
            if (_amounts[i] > 0) {
                haltStopCheckPayload[i*2] = _amounts[i];
                haltStopCheckPayload[i*2+1] = sub(shellBalances[makeKey(_shell, tokens[i])], _amounts[i]);
                shellBalances[makeKey(_shell, tokens[i])] = haltStopCheckPayload[i*2+1];
            } else {
                haltStopCheckPayload[i*2+1] = shellBalances[makeKey(_shell, tokens[i])];
            }
        }

        haltStopCheck(haltStopCheckPayload, false);

        (uint256 previousInvariant, uint256 nextInvariant) = calculateInvariants(_shell, _amounts, false);

        uint256 outstanding = shell.totalSupply();
        uint256 burned = wdiv(
            wmul(sub(previousInvariant, nextInvariant), outstanding),
            previousInvariant
        );

        shell.testBurn(msg.sender, burned);

        for (uint i = 0; i < tokens.length; i++) {
            if (_amounts[i] > 0) adjustedTransfer(ERC20Token(tokens[i]), msg.sender, _amounts[i]);
        }

        return burned;

    }

    function depositLiquidity(
        address _shell,
        uint256 amount,
        uint256 deadline
    ) external returns (uint256) {
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