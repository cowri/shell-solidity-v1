// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.5.15;

import "./LoihiRoot.sol";

contract ERC20Approve {
    function approve (address spender, uint256 amount) public returns (bool);
}

contract Loihi is LoihiRoot {

    address constant dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant cdai = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
    address constant chai = 0x06AF07097C9Eeb7fD685c692751D5C66dB49c215;

    address constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant cusdc = 0x39AA39c021dfbaE8faC545936693aC917d5E7563;

    address constant usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address constant ausdt = 0x71fc860F7D3A592A4a98740e39dB31d25db65ae8;

    address constant susd = 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51;
    address constant asusd = 0x625aE63000f46200499120B906716420bd059240;


    address constant daiAdapter = 0xe3925DEBc22B49891542a5990e781e30E15a97A3;
    address constant cdaiAdapter = 0x5152d6817952e66Cb7A0422A2F5b944d45F08e1b;
    address constant chaiAdapter = 0xc12B8e0aC01040633A935b5b13586A033000983D;

    address constant usdcAdapter = 0xE14A8eB97731a9107C9e144026765Bd65350EAC7;
    address constant cusdcAdapter = 0xf643F7A20a18557e2Aa9AF413dFA6D3626E641F8;

    address constant usdtAdapter = 0x6d05E9E964eC858Ad239755C18D288315BaDfC10;
    address constant ausdtAdapter = 0xDcE7E3AF11c3867327a7Ab786DEdFb05ef53beA5;

    address constant susdAdapter = 0x7a06041ee5140Eaf6119ADA8fA0362dF1CED9d81;
    address constant asusdAdapter = 0xE302a5E54c9e837CD1b5891F94eB6d6dF3464610;

    address constant aaveLpCore = 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3;

    // constructor () public {
    constructor (address x, address v, address l, address e) public {
        exchange = x;
        views = v;
        liquidity = l;
        erc20 = e;

        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);

        // numeraires = [ dai, usdc, usdt, susd ];

        // reserves = [ cdaiAdapter, cusdcAdapter, ausdtAdapter, asusdAdapter ];
        
        // flavors[dai] = Flavor(daiAdapter, cdaiAdapter, 300000000000000000);

        // flavors[chai] = Flavor(chaiAdapter, cdaiAdapter, 300000000000000000);

        // flavors[cdai] = Flavor(cdaiAdapter, cdaiAdapter, 300000000000000000);

        // flavors[usdc] = Flavor( usdcAdapter, cusdcAdapter, 300000000000000000);

        // flavors[cusdc] = Flavor(cusdcAdapter, cusdcAdapter, 300000000000000000);

        // flavors[usdt] = Flavor(usdtAdapter, ausdtAdapter, 300000000000000000);

        // flavors[ausdt] = Flavor(ausdtAdapter, ausdtAdapter, 300000000000000000);

        // flavors[susd] = Flavor(susdAdapter, asusdAdapter, 100000000000000000);
        
        // flavors[asusd] = Flavor(asusdAdapter, asusdAdapter, 100000000000000000);

        // address[] memory targets = new address[](5);
        // address[] memory spenders = new address[](5);
        // targets[0] = dai;
        // spenders[0] = chai;
        // targets[1] = dai;
        // spenders[1] = cdai;
        // targets[2] = susd;
        // spenders[2] = aaveLpCore;
        // targets[3] = usdc;
        // spenders[3] = cusdc;
        // targets[4] = usdt;
        // spenders[4] = aaveLpCore;

        // executeApprovals(targets, spenders);
        
        // alpha = 800000000000000000; // .8
        // beta = 400000000000000000; // .4
        // feeBase = 850000000000000; // 8.5 bps
        // feeDerivative = 100000000000000000; // .1

     }

    function supportsInterface (bytes4 interfaceID) external returns (bool) {
        return interfaceID == ERC20ID || interfaceID == ERC165ID;
    }

    function freeze (bool freeze) external onlyOwner {
        frozen = freeze;
    }

    function transferOwnership (address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function setParams (uint256 _alpha, uint256 _beta, uint256 _feeDerivative, uint256 _feeBase, uint256 _arbDerivative) public onlyOwner {
        alpha = _alpha;
        beta = _beta;
        feeDerivative = _feeDerivative;
        feeBase = _feeBase;
        arbPiece = wdiv(_arbDerivative, _feeDerivative);
    }

    function includeNumeraireReserveAndWeight (address numeraire, address reserve, uint256 weight) public onlyOwner {
        numeraires.push(numeraire);
        reserves.push(reserve);
        weights.push(weight);
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

    function staticTo(address callee, bytes memory data) internal returns (bytes memory) {
        (bool success, bytes memory returnData) = callee.call(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
        return returnData;
    }
    event log_uint(bytes32, uint256);
    /// @author james foley http://github.com/realisation
    /// @notice swap a given origin amount for a bounded minimum of the target
    /// @param _o the address of the origin
    /// @param _t the address of the target
    /// @param _oAmt the origin amount
    /// @param _mTAmt the minimum target amount 
    /// @param _dline deadline in block number after which the trade will not execute
    /// @return tAmt_ the amount of target that has been swapped for the origin
    function swapByOrigin (address _o, address _t, uint256 _oAmt, uint256 _mTAmt, uint256 _dline) external notFrozen nonReentrant returns (uint256 tAmt_) {
        bytes memory result = delegateTo(exchange, abi.encodeWithSignature("executeOriginTrade(uint256,uint256,address,address,address,uint256)", _dline, _mTAmt, msg.sender, _o, _t, _oAmt));
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
    function transferByOrigin (address _o, address _t, uint256 _oAmt, uint256 _mTAmt, uint256 _dline, address _rcpnt) external notFrozen nonReentrant returns (uint256) {
        bytes memory result = delegateTo(exchange, abi.encodeWithSignature("executeOriginTrade(uint256,uint256,address,address,address,uint256)", _dline, _mTAmt, _rcpnt, _o, _t, _oAmt));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice transfer a given origin amount into bounded minimum of the target to a specified address
    /// @param _o the address of the origin
    /// @param _t the address of the target
    /// @param _oAmt the origin amount
    /// @return tAmt_ the amount of target that has been swapped for the origin
    function viewOriginTrade (address _o, address _t, uint256 _oAmt) external notFrozen returns (uint256) {
        Flavor storage _fo = flavors[_o];
        Flavor storage _ft = flavors[_t];

        require(_fo.adapter != address(0), "origin flavor not supported");
        require(_ft.adapter != address(0), "target flavor not supported");
        
        bytes memory result = staticTo(views, abi.encodeWithSignature("getOriginViewVariables(address,address[],address,address,address,address,uint256)", 
            address(this), reserves, _fo.adapter, _fo.reserve, _ft.adapter, _ft.reserve, _oAmt));
        ( uint256[] memory viewVars ) = abi.decode(result, (uint256[]));

        emit log_uint("origin amount", viewVars[0]);
        emit log_uint("origin bal", viewVars[1]);
        emit log_uint("target bal", viewVars[2]);
        emit log_uint("gros liquidity", viewVars[3]);

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
    function viewTargetTrade (address _o, address _t, uint256 _oAmt) external notFrozen returns (uint256) {
        Flavor storage _fo = flavors[_o];
        Flavor storage _ft = flavors[_t];

        require(_fo.adapter != address(0), "origin flavor not supported"); 
        require(_ft.adapter != address(0), "target flavor not supported");

        bytes memory result = staticTo(views, abi.encodeWithSignature("getTargetViewVariables(address,address[],address,address,address,address,uint256)",
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
    function swapByTarget (address _o, address _t, uint256 _mOAmt, uint256 _tAmt, uint256 _dline) external notFrozen nonReentrant returns (uint256) {
        bytes memory result = delegateTo(exchange, abi.encodeWithSignature("executeTargetTrade(uint256,address,address,uint256,uint256,address)", _dline, _o, _t, _mOAmt, _tAmt, msg.sender));
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
    function transferByTarget (address _o, address _t, uint256 _mOAmt, uint256 _tAmt, uint256 _dline, address _rcpnt) external notFrozen nonReentrant returns (uint256) {
        bytes memory result = delegateTo(exchange, abi.encodeWithSignature("executeTargetTrade(uint256,address,address,uint256,uint256,address)", _dline, _o, _t, _mOAmt, _tAmt, _rcpnt));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice selectively deposit any supported stablecoin flavor into the contract in return for corresponding amount of shell tokens
    /// @param _flvrs an array containing the addresses of the flavors being deposited into
    /// @param _amts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function selectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _minShells, uint256 _dline) external notFrozen nonReentrant returns (uint256) {
        bytes memory result = delegateTo(liquidity, abi.encodeWithSignature("selectiveDeposit(address[],uint256[],uint256,uint256)", _flvrs, _amts, _minShells, _dline));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice deposit into the pool with no slippage from the numeraire assets the pool supports
    /// @param _totalTokens the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
    /// @return shellsToMint_ the amount of shells you receive in return for your deposit
    function proportionalDeposit (uint256 _totalTokens) external notFrozen nonReentrant returns (uint256) {
        bytes memory result = delegateTo(liquidity, abi.encodeWithSignature("proportionalDeposit(uint256)", _totalTokens));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice selectively withdrawal any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    /// @param _flvrs an array of flavors to withdraw from the reserves
    /// @param _amts an array of amounts to withdraw that maps to _flavors
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function selectiveWithdraw (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _maxShells, uint256 _dline) external notFrozen nonReentrant returns (uint256) {
        bytes memory result = delegateTo(liquidity, abi.encodeWithSignature("selectiveWithdraw(address[],uint256[],uint256,uint256)", _flvrs, _amts, _maxShells, _dline));
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @notice withdrawas amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
    /// @param _totalShells the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    /// @return withdrawnAmts_ the amount withdrawn from each of the numeraire assets
    function proportionalWithdraw (uint256 _totalShells) external nonReentrant returns (uint256[] memory) {
        bytes memory result = delegateTo(liquidity, abi.encodeWithSignature("proportionalWithdraw(uint256)", _totalShells));
        return abi.decode(result, (uint256[]));
    }

    function transfer (address recipient, uint256 amount) public nonReentrant returns (bool) {
        bytes memory result = delegateTo(erc20, abi.encodeWithSignature("transfer(address,uint256)", recipient, amount));
        return abi.decode(result, (bool));
    }

    function transferFrom (address sender, address recipient, uint256 amount) public nonReentrant returns (bool) {
        bytes memory result = delegateTo(erc20, abi.encodeWithSignature("transferFrom(address,address,uint256)", sender, recipient, amount));
        return abi.decode(result, (bool));
    }

    function approve (address spender, uint256 amount) public nonReentrant returns (bool) {
        bytes memory result = delegateTo(erc20, abi.encodeWithSignature("approve(address,uint256)", spender, amount));
        return abi.decode(result, (bool));
    }

    function balanceOf (address account) public returns (uint256) {
        return balances[account];
    }

    function allowance (address owner, address spender) public returns (uint256) {
        return allowances[owner][spender];
    }

    function getNumeraires () public returns (address[] memory) {
        return numeraires;
    }

    function getReserves () public returns (address[] memory) {
        return reserves;
    }

    function totalReserves () external returns (uint256, uint256[] memory) {
        bytes memory result = staticTo(views, abi.encodeWithSignature("totalReserves(address[],address)", reserves, address(this)));
        return abi.decode(result, (uint256, uint256[]));
    }

    function executeApprovals (address[] memory targets, address[] memory spenders) public onlyOwner {
        for (uint i = 0; i < targets.length; i++) {
            safeApprove(ERC20Approve(targets[i]), spenders[i], uint256(0));
            safeApprove(ERC20Approve(targets[i]), spenders[i], uint256(-1));
        }
    }

    function safeApprove(ERC20Approve token, address spender, uint256 value) private {
        (bool success, bytes memory returndata) = address(token).call(abi.encodeWithSelector(token.approve.selector, spender, value));
        require(success, "SafeERC20: low-level call failed");
    }


}