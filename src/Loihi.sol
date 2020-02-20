pragma solidity ^0.5.0;

import "./LoihiRoot.sol";

contract Loihi is LoihiRoot {

    constructor () public {
    // constructor (address _liquidity) public {
    // constructor (address _views) public {
    // constructor (address _exchange, address _liquidity) public {
    // constructor (address _exchange, address _views, address _liquidity) public {
    // constructor (address _exchange, address _views, address _liquidity, address _erc20) public {
        // exchange = _exchange;
        // views = _views;
        // liquidity = _liquidity;
        // erc20 = _erc20;
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);

        numeraires = [
            0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa, // dai
            0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF, // usdc
            0x13512979ADE267AB5100878E2e0f485B568328a4, // usdt
            0xD868790F57B39C9B2B51b12de046975f986675f9 // susd
        ];

        reserves = [
            0x71AB605c2C7EF07dAF4f3052DcD7953D5423Dafd, // cdai adptr
            0x23bF0abe17Ee2Fb81CF5Ae4A21473526cAD95f97, // cusdc adptr
            0x45960908CFD852791EA821D88F9cE9C4c8a649B8, // ausdt adptr
            0x0820ea95AbA96dEF58FF843DD1e26aecF4841674 // asusd adptr 
        ];
        
        // dai
        flavors[0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa] = Flavor(
            0xa557bF50Eeb88978318B3eDEE60e1781C939Acfa, // dai adptr 
            0x71AB605c2C7EF07dAF4f3052DcD7953D5423Dafd, // cdai adptr
            300000000000000000
        );

        // cdai
        flavors[0xe7bc397DBd069fC7d0109C0636d06888bb50668c] = Flavor(
            0x71AB605c2C7EF07dAF4f3052DcD7953D5423Dafd, // cdai adptr
            0x71AB605c2C7EF07dAF4f3052DcD7953D5423Dafd, // cdai adptr
            300000000000000000
        );

        // chai
        flavors[0xB641957b6c29310926110848dB2d464C8C3c3f38] = Flavor(
            0xe8E99291163839F28A2Cd195C50AE7B259272BFC, // chai adptr
            0x71AB605c2C7EF07dAF4f3052DcD7953D5423Dafd, // cdai adptr
            300000000000000000
        );

        // usdc
        flavors[0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF] = Flavor(
            0xa23F24d8d18BE37f617148CD494a1a7e83F06dAC, // usdc adptr
            0x23bF0abe17Ee2Fb81CF5Ae4A21473526cAD95f97, // cusdc adptr
            300000000000000000
        );

        // cusdc
        flavors[0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35] = Flavor(
            0x23bF0abe17Ee2Fb81CF5Ae4A21473526cAD95f97, // cusdc adptr
            0x23bF0abe17Ee2Fb81CF5Ae4A21473526cAD95f97, // cusdc adptr
            300000000000000000
        );

        // usdt
        flavors[0x13512979ADE267AB5100878E2e0f485B568328a4] = Flavor(
            0x36647002Fce1b9100DF631078E9966D842959012, // usdt adptr
            0x45960908CFD852791EA821D88F9cE9C4c8a649B8, // ausdt adptr
            300000000000000000 
        );

        // ausdt
        flavors[0xA01bA9fB493b851F4Ac5093A324CB081A909C34B] = Flavor(
            0x45960908CFD852791EA821D88F9cE9C4c8a649B8, // ausdt adptr
            0x45960908CFD852791EA821D88F9cE9C4c8a649B8, // ausdt adptr
            300000000000000000
        );

        // susd
        flavors[0xD868790F57B39C9B2B51b12de046975f986675f9] = Flavor(
            0xC35DCbf5Ec963B3789C5Eb673281B90e82d95048, // susd adptr
            0x0820ea95AbA96dEF58FF843DD1e26aecF4841674, // asusd adptr
            100000000000000000
        );
        
        // asusd
        flavors[0xb9c1434aB6d5811D1D0E92E8266A37Ae8328e901] = Flavor(
            0x0820ea95AbA96dEF58FF843DD1e26aecF4841674, // asusd adptr
            0x0820ea95AbA96dEF58FF843DD1e26aecF4841674, // asusd adptr
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

    function swapByOrigin (address _o, address _t, uint256 _oAmt, uint256 _mTAmt, uint256 _dline) external nonReentrant returns (uint256) {
        (bool success, bytes memory result) = exchange.delegatecall(abi.encodeWithSelector(0x5a9b8dc3, _o, _t, _oAmt, _mTAmt, _dline, msg.sender));
        require(success, "swap by origin failed");
        return abi.decode(result, (uint256));
    }

    function transferByOrigin (address _o, address _t, uint256 _oAmt, uint256 _mTAmt, uint256 _dline, address _rcpnt) external nonReentrant returns (uint256) {
        (bool success, bytes memory result) = exchange.delegatecall(abi.encodeWithSelector(0x5a9b8dc3, _o, _t, _oAmt, _mTAmt, _dline, _rcpnt));
        require(success, "transfer by origin failed");
        return abi.decode(result, (uint256));
    }

    function viewOriginTrade (address _o, address _t, uint256 _amt) external view returns (uint256) {
        Flavor storage _fo = flavors[_o];
        Flavor storage _ft = flavors[_t];
        
        (bool success, bytes memory result) = views.staticcall(abi.encodeWithSelector(0xb25e6987, address(this), reserves, _fo.adapter, _fo.reserve, _ft.adapter, _ft.reserve, _amt));
        ( uint256[] memory viewVars ) = abi.decode(result, (uint256[]));

        (success, result) = views.staticcall(abi.encodeWithSignature("calculateOriginTradeOriginAmount(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)", 
            _fo.weight, viewVars[1], viewVars[0], viewVars[3], alpha, beta, feeBase, feeDerivative));
        viewVars[0] = abi.decode(result, (uint256));

        if (viewVars[0] == 0) return 0;

        (success, result) = views.staticcall(abi.encodeWithSignature("calculateOriginTradeTargetAmount(address,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)", 
            _ft.adapter, _ft.weight, viewVars[2], viewVars[0], viewVars[3], alpha, beta, feeBase, feeDerivative));
        viewVars[0] = abi.decode(result, (uint256));

        return viewVars[0];

    }

    function viewTargetTrade (address _o, address _t, uint256 _amt) external view returns (uint256) {
        Flavor storage _fo = flavors[_o];
        Flavor storage _ft = flavors[_t];

        (bool success, bytes memory result) = views.staticcall(abi.encodeWithSelector(0xaab4b962,
            address(this), reserves, _fo.adapter, _fo.reserve, _ft.adapter, _ft.reserve, _amt));
        ( uint256[] memory viewVars ) = abi.decode(result, (uint256[]));

        (success, result) = views.staticcall(abi.encodeWithSignature("calculateTargetTradeTargetAmount(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)",
            _ft.weight, viewVars[1], viewVars[0], viewVars[3], alpha, beta, feeBase, feeDerivative));
        ( viewVars[0] ) = abi.decode(result, (uint256));

        if (viewVars[0] == 0) return viewVars[0];

        (success, result) = views.staticcall(abi.encodeWithSignature("calculateTargetTradeOriginAmount(address,uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)",
            _fo.adapter, _fo.weight, viewVars[2], viewVars[0], viewVars[3], alpha, beta, feeBase, feeDerivative));
        ( viewVars[0] ) = abi.decode(result, (uint256));

        return viewVars[0];

    }


    

    function swapByTarget (address _o, address _t, uint256 _mOAmt, uint256 _tAmt, uint256 _dline) external nonReentrant returns (uint256) {
        (bool success, bytes memory result) = exchange.delegatecall(abi.encodeWithSelector(0xeb85f014, _o, _t, _mOAmt, _tAmt, _dline, msg.sender));
        require(success, "swap by target failed");
        return abi.decode(result, (uint256));
    }

    function transferByTarget (address _o, address _t, uint256 _mOAmt, uint256 _tAmt, uint256 _dline, address _rcpnt) external nonReentrant returns (uint256) {
        (bool success, bytes memory result) = exchange.delegatecall(abi.encodeWithSelector(0xeb85f014, _o, _t, _mOAmt, _tAmt, _dline, _rcpnt));
        require(success, "transfer by target failed");
        return abi.decode(result, (uint256));
    }
    
    function selectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _minShells, uint256 _dline) external returns (uint256) {
        (bool success, bytes memory result) = liquidity.delegatecall(abi.encodeWithSelector(0x51dbb2a7, _flvrs, _amts, _minShells, _dline));
        require(success, "selective deposit failed");
        return abi.decode(result, (uint256));

    }

    function proportionalDeposit (uint256 _total) external returns (uint256) {
        (bool success, bytes memory result) = liquidity.delegatecall(abi.encodeWithSelector(0xdef9dfb6, _total));
        require(success, "proportional deposit failed");
        return abi.decode(result, (uint256));
    }

    function selectiveWithdraw (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _maxShells, uint256 _dline) external returns (uint256) {
        (bool success, bytes memory result) = liquidity.delegatecall(abi.encodeWithSelector(0x546e0c9b, _flvrs, _amts, _maxShells, _dline));
        require(success, "selective withdraw failed");
        return abi.decode(result, (uint256));
    }

    function proportionalWithdraw (uint256 _total) external returns (uint256[] memory) {
        (bool success, bytes memory result) = liquidity.delegatecall(abi.encodeWithSelector(0xf2a23b6c, _total));
        require(success, "proportional withdraw failed");
        return abi.decode(result, (uint256[]));
    }

    function transfer (address recipient, uint256 amount) public returns (bool) {
        (bool success, bytes memory result) = erc20.delegatecall(abi.encodeWithSelector(0xa9059cbb, recipient, amount));
        require(success, "transfer operation failed");
        return abi.decode(result, (bool));
    }

    function transferFrom (address sender, address recipient, uint256 amount) public returns (bool) {
        (bool success, bytes memory result) = erc20.delegatecall(abi.encodeWithSelector(0x23b872dd, sender, recipient, amount));
        require(success, "transfer operation failed");
        return abi.decode(result, (bool));
    }

    function approve (address spender, uint256 amount) public returns (bool) {
        (bool success, bytes memory result) = erc20.delegatecall(abi.encodeWithSelector(0x095ea7b3, spender, amount));
        require(success, "transfer operation failed");
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

    function getAdapter (address flavor) public view returns (address[] memory) {
        Flavor memory f = flavors[flavor];
        address[] memory retval = new address[](3);
        retval[0] = flavor;
        retval[1] = f.adapter;
        retval[2] = f.reserve;
        return retval;
    }

    function totalReserves () external returns (uint256, uint256[] memory) {
        (bool success, bytes memory result) = views.call(abi.encodeWithSelector(0xb8152e53, reserves, address(this)));
        require(success, "view total reserves failed");
        return abi.decode(result, (uint256, uint256[]));
    }

}