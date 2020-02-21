pragma solidity ^0.5.0;

import "./LoihiRoot.sol";

contract Loihi is LoihiRoot {

    constructor () public {
        //     constructor (address _exchange, address _views, address _liquidity, address _erc20) public {
        // exchange = _exchange;
        // views = _views;
        // liquidity = _liquidity;
        // erc20 = _erc20;
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);

        numeraires = [
            0x6B175474E89094C44Da98b954EedeAC495271d0F, // dai
            0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, // usdc
            0xdAC17F958D2ee523a2206206994597C13D831ec7, // usdt
            0x57Ab1ec28D129707052df4dF418D58a2D46d5f51 // susd
        ];

        reserves = [
            0x22c31b774018D497B110632656eF18731e602823, // cdai adptr
            0xa2762cfb37472C3B7c00017076298467Fdc7b805, // cusdc adptr
            0xD2FE45B37e58DB3452B99E232c47e4a6c52b98af, // ausdt adptr
            0xF56eD139F1c5c987e82C12F0da527723D7Ecc31C // asusd adptr 
        ];
        
        // dai
        flavors[0x6B175474E89094C44Da98b954EedeAC495271d0F] = Flavor(
            0x890C0CeAB38e1dC33fF73EE4AD19C2c4de51fE46, // dai adptr 
            0x22c31b774018D497B110632656eF18731e602823, // cdai adptr
            300000000000000000
        );

        // cdai
        flavors[0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643] = Flavor(
            0x22c31b774018D497B110632656eF18731e602823, // cdai adptr
            0x22c31b774018D497B110632656eF18731e602823, // cdai adptr
            300000000000000000
        );

        // chai
        flavors[0x06AF07097C9Eeb7fD685c692751D5C66dB49c215] = Flavor(
            0x0CBF8297339CED404c4863967B5C80BdA631f65E, // chai adptr
            0x22c31b774018D497B110632656eF18731e602823, // cdai adptr
            300000000000000000
        );

        // usdc
        flavors[0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48] = Flavor(
            0x6a90e1f881a1aC7A078a1577DdEe1230Fe744720, // usdc adptr
            0xa2762cfb37472C3B7c00017076298467Fdc7b805, // cusdc adptr
            300000000000000000
        );

        // cusdc
        flavors[0x39AA39c021dfbaE8faC545936693aC917d5E7563] = Flavor(
            0xa2762cfb37472C3B7c00017076298467Fdc7b805, // cusdc adptr
            0xa2762cfb37472C3B7c00017076298467Fdc7b805, // cusdc adptr
            300000000000000000
        );

        // usdt
        flavors[0xdAC17F958D2ee523a2206206994597C13D831ec7] = Flavor(
            0xE40cCc76C26CaA27aCC92F9C8cf28192DB7ECd82, // usdt adptr
            0xD2FE45B37e58DB3452B99E232c47e4a6c52b98af, // ausdt adptr
            300000000000000000 
        );

        // ausdt
        flavors[0x71fc860F7D3A592A4a98740e39dB31d25db65ae8] = Flavor(
            0xD2FE45B37e58DB3452B99E232c47e4a6c52b98af, // ausdt adptr
            0xD2FE45B37e58DB3452B99E232c47e4a6c52b98af, // ausdt adptr
            300000000000000000
        );

        // susd
        flavors[0x57Ab1ec28D129707052df4dF418D58a2D46d5f51] = Flavor(
            0xcBF43887aCd705d5A519025BA7db6c40C42abbe2, // susd adptr
            0xF56eD139F1c5c987e82C12F0da527723D7Ecc31C, // asusd adptr
            100000000000000000
        );
        
        // asusd
        flavors[0x625aE63000f46200499120B906716420bd059240] = Flavor(
            0xF56eD139F1c5c987e82C12F0da527723D7Ecc31C, // asusd adptr
            0xF56eD139F1c5c987e82C12F0da527723D7Ecc31C, // asusd adptr
            100000000000000000
        );

        alpha = (5 * WAD) / 10;
        beta = (25 * WAD) / 100;
        feeDerivative = WAD / 10;
        feeBase = 500000000000000;

     }

    function supportsInterface (bytes4 interfaceID) external view returns (bool) {
        return interfaceID == ERC20ID || interfaceID == ERC165ID;
    }

    modifier nonReentrant() {
        require(notEntered, "re-entered");
        notEntered = false;
        _;
        notEntered = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership (address newOwner) public {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function setParams (uint256 _alpha, uint256 _beta, uint256 _feeDerivative, uint256 _feeBase) public onlyOwner {
        alpha = _alpha;
        beta = _beta;
        feeDerivative = _feeDerivative;
        feeBase = _feeBase;
    }

    function includeNumeraireAndReserve (address numeraire, address reserve) public onlyOwner {
        numeraires.push(numeraire);
        reserves.push(reserve);
    }

    function includeAdapter (address flavor, address adapter, address reserve, uint256 weight) public onlyOwner {
        flavors[flavor] = Flavor(adapter, reserve, weight);
    }

    function excludeAdapter (address flavor) public onlyOwner {
        delete flavors[flavor];
    }

    function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
        (bool success, bytes memory returnData) = callee.delegatecall(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
        return returnData;
    }

    function staticTo(address callee, bytes memory data) internal view returns (bytes memory) {
        (bool success, bytes memory returnData) = callee.staticcall(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
        return returnData;
    }

    /// @author james foley http://github.com/realisation
    /// @notice swap a given origin amount for a bounded minimum of the target
    /// @param _o the address of the origin
    /// @param _t the address of the target
    /// @param _oAmt the origin amount
    /// @param _mTAmt the minimum target amount 
    /// @param _dline deadline in block number after which the trade will not execute
    /// @return tAmt_ the amount of target that has been swapped for the origin
    function swapByOrigin (address _o, address _t, uint256 _oAmt, uint256 _mTAmt, uint256 _dline) external nonReentrant returns (uint256 tAmt_) {
        bytes memory result = delegateTo(exchange, abi.encodeWithSelector(0x5a9b8dc3, _o, _t, _oAmt, _mTAmt, _dline, msg.sender));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice swap a given origin amount for a bounded minimum of the target
    /// @param _o the address of the origin
    /// @param _t the address of the target
    /// @param _oAmt the origin amount
    /// @param _mTAmt the minimum target amount 
    /// @param _dline deadline in block number after which the trade will not execute
    /// @param _rcpnt the address of the recipient of the target
    /// @return tAmt_ the amount of target that has been swapped for the origin
    function transferByOrigin (address _o, address _t, uint256 _oAmt, uint256 _mTAmt, uint256 _dline, address _rcpnt) external nonReentrant returns (uint256) {
        bytes memory result = delegateTo(exchange, abi.encodeWithSelector(0x5a9b8dc3, _o, _t, _oAmt, _mTAmt, _dline, _rcpnt));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice transfer a given origin amount into bounded minimum of the target to a specified address
    /// @param _o the address of the origin
    /// @param _t the address of the target
    /// @param _oAmt the origin amount
    /// @return tAmt_ the amount of target that has been swapped for the origin
    function viewOriginTrade (address _o, address _t, uint256 _oAmt) external view returns (uint256) {
        Flavor storage _fo = flavors[_o];
        Flavor storage _ft = flavors[_t];

        require(_fo.adapter != address(0), "origin flavor not supported");
        require(_ft.adapter != address(0), "target flavor not supported");
        
        bytes memory result = staticTo(views, abi.encodeWithSelector(0xb25e6987, address(this), reserves, _fo.adapter, _fo.reserve, _ft.adapter, _ft.reserve, _oAmt));
        ( uint256[] memory viewVars ) = abi.decode(result, (uint256[]));

        result = staticTo(views, abi.encodeWithSignature("calculateOriginTradeOriginAmount(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)", 
            _fo.weight, viewVars[1], viewVars[0], viewVars[3], alpha, beta, feeBase, feeDerivative));
        viewVars[0] = abi.decode(result, (uint256));

        if (viewVars[0] == 0) return 0;

        result = staticTo(views, abi.encodeWithSignature("calculateOriginTradeTargetAmount(address,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)", 
            _ft.adapter, _ft.weight, viewVars[2], viewVars[0], viewVars[3], alpha, beta, feeBase, feeDerivative));
        viewVars[0] = abi.decode(result, (uint256));

        return viewVars[0];

    }

    /// @author james foley http://github.com/realisation
    /// @notice see how much of the target you can get for an origin amount
    /// @param _o origin address
    /// @param _t target address
    /// @param _oAmt amount of origin
    /// @return _tAmt the amount of target for the origin amount
    function viewTargetTrade (address _o, address _t, uint256 _oAmt) external view returns (uint256) {
        Flavor storage _fo = flavors[_o];
        Flavor storage _ft = flavors[_t];

        require(_fo.adapter != address(0), "origin flavor not supported"); 
        require(_ft.adapter != address(0), "target flavor not supported");

        bytes memory result = staticTo(views, abi.encodeWithSelector(0xaab4b962,
            address(this), reserves, _fo.adapter, _fo.reserve, _ft.adapter, _ft.reserve, _oAmt));
        uint256[] memory viewVars = abi.decode(result, (uint256[]));

        result = staticTo(views, abi.encodeWithSignature("calculateTargetTradeTargetAmount(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)",
            _ft.weight, viewVars[1], viewVars[0], viewVars[3], alpha, beta, feeBase, feeDerivative));
        ( viewVars[0] ) = abi.decode(result, (uint256));

        if (viewVars[0] == 0) return viewVars[0];

        result = staticTo(views, abi.encodeWithSignature("calculateTargetTradeOriginAmount(address,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)",
            _fo.adapter, _fo.weight, viewVars[2], viewVars[0], viewVars[3], alpha, beta, feeBase, feeDerivative));
        ( viewVars[0] ) = abi.decode(result, (uint256));

        return viewVars[0];

    }

    /// @author james foley http://github.com/realisation
    /// @notice swap a dynamic origin amount for a fixed target amount
    /// @param _o the address of the origin
    /// @param _t the address of the target
    /// @param _mOAmt the maximum origin amount
    /// @param _tAmt the target amount 
    /// @param _dline deadline in block number after which the trade will not execute
    /// @return oAmt_ the amount of origin that has been swapped for the target
    function swapByTarget (address _o, address _t, uint256 _mOAmt, uint256 _tAmt, uint256 _dline) external nonReentrant returns (uint256) {
        bytes memory result = delegateTo(exchange, abi.encodeWithSelector(0xeb85f014, _o, _t, _mOAmt, _tAmt, _dline, msg.sender));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice transfer a dynamic origin amount into a fixed target amount at the recipients address
    /// @param _o the address of the origin
    /// @param _t the address of the target
    /// @param _mOAmt the maximum origin amount
    /// @param _tAmt the target amount 
    /// @param _dline deadline in block number after which the trade will not execute
    /// @param _rcpnt the address of the recipient of the target
    /// @return oAmt_ the amount of origin that has been swapped for the target
    function transferByTarget (address _o, address _t, uint256 _mOAmt, uint256 _tAmt, uint256 _dline, address _rcpnt) external nonReentrant returns (uint256) {
        bytes memory result = delegateTo(exchange, abi.encodeWithSelector(0xeb85f014, _o, _t, _mOAmt, _tAmt, _dline, _rcpnt));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice selectively deposit any supported stablecoin flavor into the contract in return for corresponding amount of shell tokens
    /// @param _flvrs an array containing the addresses of the flavors being deposited into
    /// @param _amts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function selectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _minShells, uint256 _dline) external returns (uint256) {
        bytes memory result = delegateTo(liquidity, abi.encodeWithSelector(0x51dbb2a7, _flvrs, _amts, _minShells, _dline));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice deposit into the pool with no slippage from the numeraire assets the pool supports
    /// @param _totalTokens the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
    /// @return shellsToMint_ the amount of shells you receive in return for your deposit
    function proportionalDeposit (uint256 _totalTokens) external returns (uint256) {
        bytes memory result = delegateTo(liquidity, abi.encodeWithSelector(0xdef9dfb6, _totalTokens));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice selectively withdrawal any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    /// @param _flvrs an array of flavors to withdraw from the reserves
    /// @param _amts an array of amounts to withdraw that maps to _flavors
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function selectiveWithdraw (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _maxShells, uint256 _dline) external returns (uint256) {
        bytes memory result = delegateTo(liquidity, abi.encodeWithSelector(0x546e0c9b, _flvrs, _amts, _maxShells, _dline));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice withdrawas amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
    /// @param _totalShells the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    /// @return withdrawnAmts_ the amount withdrawn from each of the numeraire assets
    function proportionalWithdraw (uint256 _totalShells) external returns (uint256[] memory) {
        bytes memory result = delegateTo(liquidity, abi.encodeWithSelector(0xf2a23b6c, _totalShells));
        return abi.decode(result, (uint256[]));
    }

    function transfer (address recipient, uint256 amount) public returns (bool) {
        bytes memory result = delegateTo(erc20, abi.encodeWithSelector(0xa9059cbb, recipient, amount));
        return abi.decode(result, (bool));
    }

    function transferFrom (address sender, address recipient, uint256 amount) public returns (bool) {
        bytes memory result = delegateTo(erc20, abi.encodeWithSelector(0x23b872dd, sender, recipient, amount));
        return abi.decode(result, (bool));
    }

    function approve (address spender, uint256 amount) public returns (bool) {
        bytes memory result = delegateTo(erc20, abi.encodeWithSelector(0x095ea7b3, spender, amount));
        return abi.decode(result, (bool));
    }

    function balanceOf (address account) public view returns (uint256) {
        return balances[account];
    }

    function allowance (address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }

    function getNumeraires () public view returns (address[] memory) {
        return numeraires;
    }

    function getReserves () public view returns (address[] memory) {
        return reserves;
    }

    function getAdapter (address flavor) external view returns (address[] memory) {
        Flavor memory f = flavors[flavor];
        address[] memory retval = new address[](3);
        retval[0] = flavor;
        retval[1] = f.adapter;
        retval[2] = f.reserve;
        return retval;
    }

    function totalReserves () external view returns (uint256, uint256[] memory) {
        bytes memory result = staticTo(views, abi.encodeWithSelector(0xb8152e53, reserves, address(this)));
        return abi.decode(result, (uint256, uint256[]));
    }

}