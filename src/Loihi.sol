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

pragma solidity ^0.5.0;

import "./LoihiRoot.sol";

import "./Assimilators.sol";

import "./Controller.sol";

import "./ShellsExternal.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract ERC20Approve {
    function approve (address spender, uint256 amount) public returns (bool);
}

contract Loihi is LoihiRoot {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    using Assimilators for address;
    using Shells for Shells.Shell;
    using ShellsExternal for Shells.Shell;
    using Controller for Shells.Shell;

    event ShellsMinted(address indexed minter, uint256 amount, address[] indexed coins, uint256[] amounts);
    event ShellsBurned(address indexed burner, uint256 amount, address[] indexed coins, uint256[] amounts);
    event Trade(address indexed trader, address indexed origin, address indexed target, uint256 originAmount, uint256 targetAmount);

    // using LoihiExchange for Shell;
    // using LoihiLiquidity for Shell;
    // using LoihiERC20 for Shell;
    // using LoihiDelegators for address;

    address constant dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant cdai = 0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643;
    address constant chai = 0x06AF07097C9Eeb7fD685c692751D5C66dB49c215;

    address constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant cusdc = 0x39AA39c021dfbaE8faC545936693aC917d5E7563;

    address constant usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address constant ausdt = 0x71fc860F7D3A592A4a98740e39dB31d25db65ae8;

    address constant susd = 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51;
    address constant asusd = 0x625aE63000f46200499120B906716420bd059240;

    address constant daiAdapter = 0xaC3DcacaF33626963468c58001414aDf1a4CCF86;
    address constant cdaiAdapter = 0xA5F095e778B30DcE3AD25D5A545e3e9d6092f1Af;
    address constant chaiAdapter = 0x251D87F3d6581ae430a8Df18C2474DA07C569615;

    address constant usdcAdapter = 0x98dD552EaEc607f9804fbd9758Df9C30Ada60B7B;
    address constant cusdcAdapter = 0xA189607D20afFA0b1a578f9D14040822D507978F;

    address constant usdtAdapter = 0xCd0dA368E6e32912DD6633767850751969346d15;
    address constant ausdtAdapter = 0xA4906F20a7806ca28626d3D607F9a594f1B9ed3B;

    address constant susdAdapter = 0x4CB5174C962a40177876799836f353e8E9c4eF75;
    address constant asusdAdapter = 0x68747564d7B4e7b654BE26D09f60f7756Cf54BF8;

    address constant aaveLpCore = 0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3;

    // constructor () public {
    constructor () public {

        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);

        shell.testHalts = true;

        // shell = Shell();

        // shell.numeraires = [ dai, usdc, usdt, susd ];
        // shell.reserves = [ cdaiAdapter, cusdcAdapter, ausdtAdapter, asusdAdapter ];
        // shell.weights = [ 300000000000000000, 300000000000000000, 300000000000000000, 100000000000000000 ];

        // shell.assimilators[dai] = Assimilator(daiAdapter, cdaiAdapter);
        // shell.assimilators[chai] = Assimilator(chaiAdapter, cdaiAdapter);
        // shell.assimilators[cdai] = Assimilator(cdaiAdapter, cdaiAdapter);
        // shell.assimilators[usdc] = Assimilator(usdcAdapter, cusdcAdapter);
        // shell.assimilators[cusdc] = Assimilator(cusdcAdapter, cusdcAdapter);
        // shell.assimilators[usdt] = Assimilator(usdtAdapter, ausdtAdapter);
        // shell.assimilators[ausdt] = Assimilator(ausdtAdapter, ausdtAdapter);
        // shell.assimilators[susd] = Assimilator(susdAdapter, asusdAdapter);
        // shell.assimilators[asusd] = Assimilator(asusdAdapter, asusdAdapter);

        // address[] memory targets = new address[](5);
        // address[] memory spenders = new address[](5);
        // targets[0] = dai; spenders[0] = chai;
        // targets[1] = dai; spenders[1] = cdai;
        // targets[2] = susd; spenders[2] = aaveLpCore;
        // targets[3] = usdc; spenders[3] = cusdc;
        // targets[4] = usdt; spenders[4] = aaveLpCore;

        // for (uint i = 0; i < targets.length; i++) {
        //     (bool success, bytes memory returndata) = targets[i].call(abi.encodeWithSignature("approve(address,uint256)", spenders[i], uint256(0)));
        //     require(success, "SafeERC20: low-level call failed");
        //     (success, returndata) = targets[i].call(abi.encodeWithSignature("approve(address,uint256)", spenders[i], uint256(-1)));
        //     require(success, "SafeERC20: low-level call failed");
        // }

        // alpha = 900000000000000000; // .9
        // beta = 400000000000000000; // .4
        // delta = 150000000000000000; // .15
        // epsilon = 175000000000000; // 1.75 bps * 2 = 3.5 bps
        // lambda = 500000000000000000; // .5

    }

    function setParams (uint256 _alpha, uint256 _beta, uint256 _epsilon, uint256 _max, uint256 _lambda) public onlyOwner {
        maxFee = shell.setParams(_alpha, _beta, _epsilon, _max, _lambda);
    }

    function includeAsset (address _numeraire, address _nAssim, address _reserve, address _rAssim, uint256 _weight) public onlyOwner {
        shell.includeAsset(_numeraire, _nAssim, _reserve, _rAssim, _weight);
    }

    function includeAssimilator (address _numeraire, address _derivative, address _assimilator) public onlyOwner {
        shell.includeAssimilator(_numeraire, _derivative, _assimilator);
    }

    function excludeAdapter (address _assimilator) external onlyOwner {
        delete shell.assimilators[_assimilator];
    }

    function supportsInterface (bytes4 interfaceID) public returns (bool) {
        return interfaceID == ERC20ID || interfaceID == ERC165ID;
    }

    function freeze (bool _freeze) public onlyOwner {
        frozen = _freeze;
    }

    function transferOwnership (address _newOwner) public onlyOwner {
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    function swapByOrigin (address _o, address _t, uint256 _oAmt, uint256 _mTAmt, uint256 _dline) public notFrozen returns (uint256 tAmt_) {

        return transferByOrigin(_o, _t, _dline, _mTAmt, _oAmt, msg.sender);

    }

    function getSwapData (
        uint _lIx,
        uint _rIx,
        uint _amt,
        address _assim,
        bool _isOrigin,
        address _rcpnt
    ) internal returns (
        int128 amt_,
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.reserves.length;

        int128[] memory oBals_ = new int128[](_length);
        int128[] memory nBals_ = new int128[](_length);

        for (uint i = 0; i < _length; i++) {

            if (i != _lIx) nBals_[i] = oBals_[i] = shell.reserves[i].addr.viewNumeraireBalance();
            else {

                int128 _bal;
                if (_isOrigin) ( amt_, _bal ) = _assim.intakeRawAndGetBalance(_amt);
                else ( amt_, _bal ) = _assim.outputRawAndGetBalance(_rcpnt, _amt);

                oBals_[i] = _bal - amt_;
                nBals_[i] = _bal;

            }

            oGLiq_ += oBals_[i];
            nGLiq_ += nBals_[i];

        }

        nGLiq_ = nGLiq_.sub(amt_);
        nBals_[_rIx] = nBals_[_rIx].sub(amt_);

        // emit log_int("amt_", amt_.muli(1e18));
        // emit log_int("oGLiq_", oGLiq_.muli(1e18));
        // for (uint i = 0; i < oBals_.length; i++) emit log_int("oBals_ from getSwapData", oBals_[i].muli(1e18));
        // emit log_int("nGLiq_", nGLiq_.muli(1e18));
        // for (uint i = 0; i < nBals_.length; i++) emit log_int("nBals_ from getSwapData", nBals_[i].muli(1e18));

        return ( amt_, oGLiq_, nGLiq_, oBals_, nBals_ );

    }

    function viewSwapData (
        uint _lIx,
        uint _rIx,
        uint _amt,
        bool _isOrigin,
        address _assim
    ) internal returns (
        int128 amt_,
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.reserves.length;
        int128[] memory nBals_ = new int128[](_length);
        int128[] memory oBals_ = new int128[](_length);

        for (uint i = 0; i < _length; i++) {

            if (i != _lIx) nBals_[i] = oBals_[i] = shell.reserves[i].addr.viewNumeraireBalance();
            else {

                int128 _bal;
                ( amt_, _bal ) = _assim.viewNumeraireAmountAndBalance(_amt);
                if (!_isOrigin) amt_ = amt_.neg();

                oBals_[i] = _bal;
                nBals_[i] = _bal.add(amt_);

            }

            oGLiq_ += oBals_[i];
            nGLiq_ += nBals_[i];

        }

        nGLiq_ = nGLiq_.sub(amt_);
        nBals_[_rIx] = nBals_[_rIx].sub(amt_);

        return ( amt_, oGLiq_, nGLiq_, nBals_, oBals_ );

    }

    function transferByOrigin (address _origin, address _target, uint256 _dline, uint256 _mTAmt, uint256 _oAmt, address _rcpnt) public notFrozen nonReentrant returns (uint256 tAmt_) {

        Assimilators.Assimilator memory _o = shell.assimilators[_origin];
        Assimilators.Assimilator memory _t = shell.assimilators[_target];

        // TODO: how to include min target amount
        if (_o.ix == _t.ix) return _t.addr.outputNumeraire(_rcpnt, _o.addr.intakeRaw(_oAmt));

        (   int128 _amt,
            int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = getSwapData(_o.ix, _t.ix, _oAmt, _o.addr, true, address(0));

        // emit log_int("shell.omega", shell.omega.muli(1e18));
        // emit log_int("_amt", _amt.muli(1e18));
        // emit log_int("_oGLiq", _oGLiq.muli(1e18));
        // for (uint i = 0; i < _oBals.length; i++) emit log_int("_oBals from transferByOrigin", _oBals[i].muli(1e18));
        // emit log_int("_nGLiq", _nGLiq.muli(1e18));
        // for (uint i = 0; i < _nBals.length; i++) emit log_int("_nBals from transferByOrigin", _nBals[i].muli(1e18));

        ( _amt, shell.omega ) = shell.calculateOriginTrade(_t.ix, _amt, _oGLiq, _nGLiq, _oBals, _nBals);

        // emit log_int("shell.omega", shell.omega.muli(1e18));
        // emit log_int("_amt", _amt.muli(1e18));

        require((tAmt_ = _t.addr.outputNumeraire(_rcpnt, _amt)) > _mTAmt, "Shell/below-min-target-amount");

        emit Trade(msg.sender, _origin, _target, _oAmt, tAmt_);

    }

    function prime () public {

        int128 _oGLiq;
        int128[] memory _oBals;
        uint256 _length = shell.reserves.length;

        for (uint i = 0; i < _length; i++) {
            int128 _bal = shell.reserves[i].addr.viewNumeraireBalance();
            _oGLiq += _bal;
            _oBals[i] = _bal;
        }

        shell.omega = shell.calculateFee(_oBals, _oGLiq);

    }

    /// @author james foley http://github.com/realisation
    /// @notice view how much of the target currency the origin currency will provide
    /// @param _origin the address of the origin
    /// @param _target the address of the target
    /// @param _oAmt the origin amount
    /// @return tAmt_ the amount of target that has been swapped for the origin
    function viewOriginTrade (address _origin, address _target, uint256 _oAmt) public notFrozen returns (uint256) {

        Assimilators.Assimilator memory _o = shell.assimilators[_origin];
        Assimilators.Assimilator memory _t = shell.assimilators[_target];

        if (_o.ix == _t.ix) return _t.addr.viewRawAmount(_o.addr.viewNumeraireAmount(_oAmt));

        (   int128 _amt,
            int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _nBals,
            int128[] memory _oBals ) = viewSwapData(_o.ix, _t.ix, _oAmt, true, _o.addr);

        ( _amt, ) = shell.calculateOriginTrade(_t.ix, _amt, _oGLiq, _nGLiq, _oBals, _nBals);

        return  _target.viewRawAmount(_amt);

    }

    /// @author james foley http://github.com/realisation
    /// @notice swap a dynamic origin amount for a fixed target amount
    /// @param _origin the address of the origin
    /// @param _target the address of the target
    /// @param _mOAmt the maximum origin amount
    /// @param _tAmt the target amount
    /// @param _dline deadline in block number after which the trade will not execute
    /// @return oAmt_ the amount of origin that has been swapped for the target
    function swapByTarget (address _origin, address _target, uint256 _mOAmt, uint256 _tAmt, uint256 _dline) public notFrozen returns (uint256) {

        return transferByTarget(_origin, _target, _mOAmt, _dline, _tAmt, msg.sender);

    }

    /// @author james foley http://github.com/realisation
    /// @notice transfer a dynamic origin amount into a fixed target amount at the recipients address
    /// @param _origin the address of the origin
    /// @param _target the address of the target
    /// @param _mOAmt the maximum origin amount
    /// @param _tAmt the target amount
    /// @param _dline deadline in block number after which the trade will not execute
    /// @param _rcpnt the address of the recipient of the target
    /// @return oAmt_ the amount of origin that has been swapped for the target
    function transferByTarget (address _origin, address _target, uint256 _mOAmt, uint256 _dline, uint256 _tAmt, address _rcpnt) public notFrozen nonReentrant returns (uint256 oAmt_) {

        uint _length = shell.reserves.length;
        Assimilators.Assimilator memory _o = shell.assimilators[_origin];
        Assimilators.Assimilator memory _t = shell.assimilators[_target];

        // TODO: how to incorporate max origin amount
        if (_o.ix == _t.ix) return _o.addr.intakeNumeraire(_t.addr.outputRaw(_rcpnt, _tAmt));

        (   int128 _amt,
            int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals) = getSwapData(_t.ix, _o.ix, _tAmt, _t.addr, false, _rcpnt);

        ( _amt, shell.omega ) = shell.calculateTargetTrade(_o.ix, _amt, _oGLiq, _nGLiq, _oBals, _nBals);

        require((oAmt_ = _o.addr.intakeNumeraire(_amt)) < _mOAmt, "above-maximum-origin-amount");

        emit Trade(msg.sender, _origin, _target, oAmt_, _tAmt);

    }

    /// @author james foley http://github.com/realisation
    /// @notice view how much of the origin currency the target currency will take
    /// @param _origin the address of the origin
    /// @param _target the address of the target
    /// @param _tAmt the target amount
    /// @return oAmt_ the amount of target that has been swapped for the origin
    function viewTargetTrade (address _origin, address _target, uint256 _tAmt) public notFrozen returns (uint256 oAmt_) {

        Assimilators.Assimilator memory _o = shell.assimilators[_origin];
        Assimilators.Assimilator memory _t = shell.assimilators[_target];

        if (_o.ix == _t.ix) return _o.addr.viewRawAmount(_t.addr.viewNumeraireAmount(_tAmt));

        (   int128 _amt,
            int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _nBals,
            int128[] memory _oBals ) = viewSwapData(_t.ix, _o.ix, _tAmt, false, _t.addr);

        ( _amt, ) = shell.calculateTargetTrade(_o.ix, _amt, _oGLiq, _nGLiq, _oBals, _nBals);

        _amt = _amt.mul(ONE.add(shell.epsilon));

        oAmt_ = _origin.viewRawAmount(_amt);

    }

    function getLiquidityData (
        address[] memory _flvrs,
        uint256[] memory _amts,
        bool _isDeposit,
        address _rcpnt
    ) internal returns (
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {


        // emit log_uints("_amts", _amts);
        // emit log_addrs("_flvrs", _flvrs);
        uint _length = shell.reserves.length;
        // emit log_uint("_length", _length);
        int128[] memory oBals_ = new int128[](_length);
        int128[] memory nBals_ = new int128[](_length);

        for (uint i = 0; i < _flvrs.length; i++) {

            Assimilators.Assimilator memory _assim = shell.assimilators[_flvrs[i]];

            if ( nBals_[_assim.ix] == 0 && oBals_[_assim.ix] == 0 ) {

                // emit log("ping");

                int128 _amount; int128 _balance;

                if (_isDeposit) ( _amount, _balance ) = _assim.addr.intakeRawAndGetBalance(_amts[i]);
                else ( _amount, _balance ) = _assim.addr.outputRawAndGetBalance(_rcpnt, _amts[i]);

                nBals_[_assim.ix] = _balance;
                oBals_[_assim.ix] = _balance.sub(_amount);

            } else {

                int128 _amount;

                if (_isDeposit) _amount = _assim.addr.intakeRaw(_amts[i]);
                else _amount = _assim.addr.outputRaw(_rcpnt, _amts[i]);

                nBals_[_assim.ix] = nBals_[_assim.ix].sub(_amount);

            }

        }

        for (uint i = 0; i < _length; i++) {

            if (oBals_[i] == 0 && nBals_[i] == 0) nBals_[i] = oBals_[i] = shell.reserves[i].addr.viewNumeraireBalance();

            oGLiq_ += oBals_[i];
            nGLiq_ += nBals_[i];

        }

        return ( oGLiq_, nGLiq_, oBals_, nBals_ );

    }

    function viewLiquidityData (address[] memory _flvrs, uint[] memory _amts, bool _isDeposit) internal returns (
        int128 oGLiq_,
        int128 nGLiq_,
        int128[] memory,
        int128[] memory
    ) {

        uint _length = shell.reserves.length;
        int128[] memory oBals_ = new int128[](_length);
        int128[] memory nBals_ = new int128[](_length);

        for (uint i = 0; i < _flvrs.length; i++) {

            Assimilators.Assimilator memory _assim = shell.assimilators[_flvrs[i]];

            if ( nBals_[_assim.ix] == 0 && oBals_[_assim.ix] == 0 ) {

                ( int128 _amount, int128 _balance ) = _assim.addr.viewNumeraireAmountAndBalance(_amts[i]);
                if (!_isDeposit) _amount = _amount.neg();
                nBals_[_assim.ix] = _balance.sub(_amount);
                oBals_[_assim.ix] = _balance;


            } else {

                int128 _amount = _assim.addr.viewNumeraireAmount(_amts[i]);
                if (!_isDeposit) _amount = _amount.neg();

                nBals_[_assim.ix] = nBals_[_assim.ix].sub(_amount);

            }

        }

        for (uint i = 0; i < _length; i++) {

            int128 _bal;

            if (oBals_[i] == 0 && nBals_[i] == 0) _bal = nBals_[i] = oBals_[i] = shell.reserves[i].addr.viewNumeraireBalance();

            oGLiq_ += _bal;
            nGLiq_ += _bal;

        }

        return ( oGLiq_, nGLiq_, oBals_, nBals_ );

    }

    /// @author james foley http://github.com/realisation
    /// @notice selectively deposit any supported stablecoin flavor into the contract in return for corresponding amount of shell tokens
    /// @param _flvrs an array containing the addresses of the flavors being deposited into
    /// @param _amts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    /// @param _minShells minimum acceptable amount of shells
    /// @param _dline deadline for tx
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function selectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _minShells, uint256 _dline) external notFrozen nonReentrant returns (uint256 shells_) {
        require(block.timestamp < _dline, "Shell/tx-deadline-passed");

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = getLiquidityData(_flvrs, _amts, true, address(0));

        // emit log_int("_oGLiq", _oGLiq.muli(1e18));
        // emit log_int("_nGLiq", _nGLiq.muli(1e18));
        // emit log_ints("_oBals", _oBals);
        // emit log_ints("_nBals", _nBals);

        ( shells_, shell.omega ) = shell.calculateSelectiveDeposit(_oGLiq, _nGLiq, _oBals, _nBals);

        require(_minShells < shells_, "Shell/under-minimum-shells");

        shell.mint(msg.sender, shells_);

    }

    /// @author james folew http://github.com/realisation
    /// @notice view how many shell tokens a deposit will mint
    /// @param _flvrs an array containing the addresses of the flavors being deposited into
    /// @param _amts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function viewSelectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts) external notFrozen returns (uint256 shells_) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = viewLiquidityData(_flvrs, _amts, true);

        ( shells_, ) = shell.calculateSelectiveDeposit(_oGLiq, _nGLiq, _oBals, _nBals);

    }

    event log_int(bytes32, int);
    event log_ints(bytes32, int128[]);
    event log_uint(bytes32, uint);
    event log_uints(bytes32, uint[]);
    event log_addrs(bytes32, address[]);

    /// @author james foley http://github.com/realisation
    /// @notice deposit into the pool with no slippage from the numeraire assets the pool supports
    /// @param  _deposit the full amount you want to deposit into the pool which will be divided up evenly amongst the numeraire assets of the pool
    /// @return shellsToMint_ the amount of shells you receive in return for your deposit
    function proportionalDeposit (uint256 _deposit) public notFrozen nonReentrant returns (uint256 shells_) {

        int128 _shells = _deposit.divu(1e18);

        uint _length = shell.reserves.length;
        int128 _oGLiq;
        int128[] memory _oBals = new int128[](_length);
        for (uint i = 0; i < _length; i++) {
            int128 _bal = shell.reserves[i].addr.viewNumeraireBalance();
            _oBals[i] = _bal;
            _oGLiq += _bal;
        }

        if (_oGLiq == 0) {

            for (uint8 i = 0; i < _length; i++) {

                shell.numeraires[i].addr.intakeNumeraire(_shells.mul(shell.weights[i]));

            }

        } else {

            int128 _multiplier = _shells.div(_oGLiq);

            shell.omega = shell.omega.mul(ONE.add(_multiplier));

            for (uint8 i = 0; i < _length; i++) {

                shell.numeraires[i].addr.intakeNumeraire(_oBals[i].mul(_multiplier));

            }

        }

        if (shell.totalSupply > 0) _shells = _shells.div(_oGLiq).mul(shell.totalSupply.divu(1e18));

        shell.mint(msg.sender, shells_ = _shells.mulu(1e18));

    }

    /// @author james foley http://github.com/realisation
    /// @notice selectively withdrawal any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    /// @param _flvrs an array of flavors to withdraw from the reserves
    /// @param _amts an array of amounts to withdraw that maps to _flavors
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function selectiveWithdraw (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _maxShells, uint256 _dline) external notFrozen nonReentrant returns (uint256 shells_) {
        require(block.timestamp < _dline, "Shell/tx-deadline-passed");

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = getLiquidityData(_flvrs, _amts, false, msg.sender);

        ( shells_, shell.omega ) = shell.calculateSelectiveWithdraw(_oGLiq, _nGLiq, _oBals, _nBals);

        require(shells_ < _maxShells, "Shell/above-maximum-shells");

        shell.burn(msg.sender, shells_);

    }

    /// @author james foley http://github.com/realisation
    /// @notice view how many shell tokens a withdraw will consume
    /// @param _flvrs an array of flavors to withdraw from the reserves
    /// @param _amts an array of amounts to withdraw that maps to _flavors
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function viewSelectiveWithdraw (address[] calldata _flvrs, uint256[] calldata _amts) external notFrozen returns (uint256 shells_) {

        (   int128 _oGLiq,
            int128 _nGLiq,
            int128[] memory _oBals,
            int128[] memory _nBals ) = viewLiquidityData(_flvrs, _amts, false);

        ( shells_, ) = shell.calculateSelectiveWithdraw(_oGLiq, _nGLiq, _oBals, _nBals);

    }

    /// @author  james foley http://github.com/realisation
    /// @notice  withdrawas amount of shell tokens from the the pool equally from the numeraire assets of the pool with no slippage
    /// @param   _withdrawal the full amount you want to withdraw from the pool which will be withdrawn from evenly amongst the numeraire assets of the pool
    function proportionalWithdraw (uint256 _withdrawal) public nonReentrant {
        
        uint _length = shell.reserves.length;
        int128 _oGLiq; int128[] memory _oBals;
        for (uint i = 0; i < _length; i++) {
            int128 _bal = shell.reserves[i].addr.viewNumeraireBalance();
            _oGLiq += _bal;
            _oBals[i] = _bal;
        }

        int128 _multiplier = _withdrawal.divu(1e18)
            .mul(ONE.sub(shell.epsilon))
            .div(shell.totalSupply.divu(1e18));

        for (uint8 i = 0; i < shell.reserves.length; i++) {

            shell.reserves[i].addr.outputNumeraire(msg.sender, _oBals[i].mul(_multiplier));

        }

        shell.omega = shell.omega.mul(ONE.sub(_multiplier));

        shell.burn(msg.sender, _withdrawal);

    }

    function transfer (address _recipient, uint256 _amount) public nonReentrant returns (bool) {
        // return shell.transfer(_recipient, _amount);
    }

    function transferFrom (address _sender, address _recipient, uint256 _amount) public nonReentrant returns (bool) {
        // return shell.transferFrom(_sender, _recipient, _amount);
    }

    function approve (address _spender, uint256 _amount) public nonReentrant returns (bool) {
        // return shell.approve(_spender, _amount);
    }

    function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
        // return shell.increaseAllowance(_spender, _addedValue);
    }

    function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
        // return shell.decreaseAllowance(_spender, _subtractedValue);
    }

    function balanceOf (address _account) public view returns (uint256) {
        // return shell.balances[_account];
    }

    function totalSupply () public view returns (uint256 totalSupply_) {
        totalSupply_ = shell.totalSupply;
    }

    function allowance (address _owner, address _spender) public view returns (uint256) {
        // return shell.allowances[_owner][_spender];
    }

    function totalReserves () public returns (uint256, uint256[] memory) {

        uint _length;
        uint totalBalance_;
        uint[] memory balances_ = new uint256[](_length);
        for (uint i = 0; i < _length; i++) {
            uint256 _bal = shell.reserves[i].addr.viewNumeraireBalance().mulu(1e18);
            balances_[i] = _bal;
            totalBalance_ += _bal;
        }
        return (totalBalance_, balances_);
    }

    function safeApprove(address _token, address _spender, uint256 _value) public onlyOwner {

        (bool success, bytes memory returndata) = _token.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));

        require(success, "SafeERC20: low-level call failed");

    }

}
