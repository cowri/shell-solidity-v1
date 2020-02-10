pragma solidity ^0.5.12;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./IChai.sol";
import "./ICToken.sol";
import "./IPot.sol";
import "./LoihiRoot.sol";

contract Loihi is LoihiRoot {

    // Local
    // IChai chai;
    // ICToken cdai;
    // IERC20 dai;
    // IPot pot;
    // ICToken cusdc;
    // IERC20 usdc;
    // IERC20 usdt;

    // KOVAN
    // IChai public chai = IChai(0xB641957b6c29310926110848dB2d464C8C3c3f38);
    // ICToken public cdai = ICToken(0xe7bc397DBd069fC7d0109C0636d06888bb50668c);
    // IERC20 public dai = IERC20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
    // IPot public pot = IPot(0xEA190DBDC7adF265260ec4dA6e9675Fd4f5A78bb);
    // ICToken public cusdc = ICToken(0xcfC9bB230F00bFFDB560fCe2428b4E05F3442E35);
    // IERC20 public usdc = IERC20(0x75B0622Cec14130172EaE9Cf166B92E5C112FaFF);
    // IERC20 public usdt = IERC20(0x20F7963EF38AC716A85ed18fb683f064db944648);


    // // MAINNET
    // ChaiI constant internal chai = ChaiI(0x06AF07097C9Eeb7fD685c692751D5C66dB49c215);
    // CTokenI constant internal cdai = CTokenI(0x5d3a536e4d6dbd6114cc1ead35777bab948e3643);
    // ERC20I constant internal dai = ERC20I(0x6b175474e89094c44da98b954eedeac495271d0f);
    // PotI constant internal pot = PotI(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);
    // CTokenI constant internal cusdc = CTokenI(0x39aa39c021dfbae8fac545936693ac917d5e7563);
    // ERC20I constant internal usdc = ERC20I(0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48);
    // IERC20 constant internal usdt = ERC20I(0xdac17f958d2ee523a2206206994597c13d831ec7);

    event log_address(bytes32, address);

    constructor (address _chai, address _cdai, address _dai, address _pot, address _cusdc, address _usdc, address _usdt) public {
        // chai = IChai(_chai);
        // cdai = ICToken(_cdai);
        // dai = IERC20(_dai);
        // pot = IPot(_pot);
        // cusdc = ICToken(_cusdc);
        // usdc = IERC20(_usdc);
        // usdt = IERC20(_usdt);
    }

    function supportsInterface (bytes4 interfaceID) external view returns (bool) {
        return interfaceID == ERC20ID
            || interfaceID == ERC165ID;
    }

    function fakeMint (uint256 amount) public {
        _mint(msg.sender, amount);
    }

    function setAlpha (uint256 _alpha) public {
        alpha = _alpha;
    }

    function setBeta (uint256 _beta) public {
        beta = _beta;
    }

    function setFeeDerivative (uint256 _feeDerivative) public {
        feeDerivative = _feeDerivative;
    }

    function setFeeBase (uint256 _feeBase) public {
        feeBase = _feeBase;
    }

    function includeNumeraireAndReserve (address numeraire, address reserve) public {
        numeraires.push(numeraire);
        reserves.push(reserve);
    }

    function includeAdapter (address flavor, address adapter, address reserve, uint256 weight) public {
        flavors[flavor] = Flavor(adapter, reserve, weight);
    }

    function excludeAdapter (address flavor) public {
        delete flavors[flavor];
    }

    function dGetNumeraireAmount (address addr, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xb2e87f0f, amount)); // encoded selector of "getNumeraireAmount(uint256");
        assert(success);
        return abi.decode(result, (uint256));
    }

    function dGetNumeraireBalance (address addr) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0x10df6430)); // encoded selector of "getNumeraireBalance()";
        assert(success);
        return abi.decode(result, (uint256));
    }

    /// @dev this function delegate calls addr, which is an interface to the required functions for retrieving and transfering numeraire and raw values and vice versa
    /// @param addr the address to the interface wrapper to be delegatecall'd
    /// @param amount the numeraire amount to be transfered into the contract. will be adjusted to the raw amount before transfer
    function dIntakeRaw (address addr, uint256 amount) internal {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xfa00102a, amount)); // encoded selector of "intakeRaw(uint256)";
        assert(success);
    }

    /// @dev this function delegate calls addr, which is an interface to the required functions for retrieving and transfering numeraire and raw values and vice versa
    /// @param addr the address to the interface wrapper to be delegatecall'd
    /// @param amount the numeraire amount to be transfered into the contract. will be adjusted to the raw amount before transfer
    function dIntakeNumeraire (address addr, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0x7695ab51, amount)); // encoded selector of "intakeNumeraire(uint256)";
        assert(success);
        return abi.decode(result, (uint256));
    }

    /// @dev this function delegate calls addr, which is an interface to the required functions for retrieving and transfering numeraire and raw values and vice versa
    /// @param addr the address of the interface wrapper to be delegatecall'd
    /// @param dst the destination to which to send the raw amount
    /// @param amount the raw amount of the asset to send
    function dOutputRaw (address addr, address dst, uint256 amount) internal {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xf09a3fc3, dst, amount)); // encoded selector of "outputRaw(address,uint256)";
        assert(success);
    }

    /// @dev this function delegate calls addr, which is an interface to the required functions to retrieve the numeraire and raw values and vice versa
    /// @param addr address of the interface wrapper
    /// @param dst the destination to send the raw amount to
    /// @param amount the numeraire amount of the asset to be sent. this will be adjusted to the corresponding raw amount
    /// @return the raw amount of the asset that was transfered
    function dOutputNumeraire (address addr, address dst, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xef40df22, dst, amount)); // encoded selector of "outputNumeraire(address,uint256)";
        assert(success);
        return abi.decode(result, (uint256));
    }

    function swapByTarget (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline) public returns (uint256) {
        return executeTargetTrade(origin, target, maxOriginAmount, targetAmount, deadline, msg.sender);
    }
    function transferByTarget (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeTargetTrade(origin, target, maxOriginAmount, targetAmount, deadline, recipient);
    }
    function swapByOrigin (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline) public returns (uint256) {
        return executeOriginTrade(origin, target, originAmount, minTargetAmount, deadline, msg.sender);
    }
    function transferByOrigin (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeOriginTrade(origin, target, originAmount, minTargetAmount, deadline, recipient);
    }

    event log_uint(bytes32, uint256);

    /// @author James Foley http://github.com/realisation
    /// @notice given an origin amount this function will find the corresponding target amount according to the contracts state and make the swap between the two
    /// @param _origin the address of the origin flavor
    /// @param _target the address of the target flavor
    /// @param _oAmt the raw amount of the origin flavor - will be converted to numeraire amount
    /// @param _minTAmt the minimum target amount you are willing to accept for this trade
    /// @param _deadline the block by which this transaction is no longer valid
    /// @param _recipient the address for where to send the resultant target amount
    /// @return tNAmt_ the target numeraire amount
    function executeOriginTrade (address _origin, address _target, uint256 _oAmt, uint256 _minTAmt, uint256 _deadline, address _recipient) public returns (uint256) {

        Flavor memory _o = flavors[_origin]; // origin adapter + weight
        Flavor memory _t = flavors[_target]; // target adapter + weight

        ( uint256 _oNAmt,
          uint256 _oBal,
          uint256 _tBal,
          uint256 _tNAmt,
          uint256 _grossLiq ) = getOriginTradeVariables(_o, _t, _oAmt);

        _oNAmt = calculateOriginTradeOriginAmount(_o.weight, _oBal, _oNAmt, _grossLiq);
        _tNAmt = calculateOriginTradeTargetAmount(_t.weight, _tBal, _oNAmt, _grossLiq);

        dIntakeNumeraire(_o.adapter, _oNAmt);
        return dOutputNumeraire(_t.adapter, _recipient, _tNAmt);

    }

    /// @author James Foley http://github.com/realisation
    /// @notice builds the relevant variables for a target trade
    /// @param _o the record for the origin flavor containing the address of its adapter and its reserve
    /// @param _t the record for the target flavor containing the address of its adapter and its reserve
    /// @param _oAmt the raw amount of the origin flavor to be converted into numeraire
    /// @return oNAmt_ the numeraire amount of the origin flavor
    /// @return oBal_ the new origin numeraire balance including the origin numeraire amount
    /// @return tBal_ the current numereraire balance of the contracts reserve for the target
    /// @return tNAmt_ empty value to be filled in when the target fee is calculated
    /// @return grossLiq_ total numeraire value across all reserves in the contract
    function getOriginTradeVariables (Flavor memory _o, Flavor memory _t, uint256 _oAmt) private returns (uint, uint, uint, uint, uint) {

        uint oNAmt_;
        uint oBal_;
        uint tBal_;
        uint tNAmt_;
        uint grossLiq_;

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] == _o.reserve) {
                oNAmt_ = dGetNumeraireAmount(_o.adapter, _oAmt);
                oBal_ = dGetNumeraireBalance(_o.adapter);
                grossLiq_ += oBal_;
                oBal_ = add(oBal_, oNAmt_);
            } else if (reserves[i] == _t.reserve) {
                tBal_ = dGetNumeraireBalance(_t.adapter);
                grossLiq_ += tBal_;
            } else {
                grossLiq_ += dGetNumeraireBalance(reserves[i]);
            }
        }

        return (oNAmt_, oBal_, tBal_, tNAmt_, grossLiq_);

    }

    /// @author James Foley http://github.com/realisation
    /// @notice calculates the origin amount in an origin trade including the fees
    /// @param _oWeight the balance weighting of the origin flavor
    /// @param _oBal the new numeraire balance of the origin reserve including the origin amount being swapped
    /// @param _oNAmt the origin numeraire amount being swapped
    /// @param _grossLiq the numeraire amount across all stablecoin reserves in the contract
    /// @return oNAmt_ the origin numeraire amount for the swap with fees applied
    function calculateOriginTradeOriginAmount (uint256 _oWeight, uint256 _oBal, uint256 _oNAmt, uint256 _grossLiq) private returns (uint256) {

        emit log_uint("ping",0);

        require(_oBal <= wmul(_oWeight, wmul(_grossLiq, alpha + WAD)), "origin swap origin halt check");
        emit log_uint("ping",0);

        uint256 oNAmt_;

        emit log_uint("ping",0);
        uint256 _feeThreshold = wmul(_oWeight, wmul(_grossLiq, beta + WAD));
        emit log_uint("ping", _feeThreshold);
        if (_oBal < _feeThreshold) {
        emit log_uint("ping",0);

            oNAmt_ = _oNAmt;

        } else if (sub(_oBal, _oNAmt) >= _feeThreshold) {

        emit log_uint("ping",0);
            uint256 _fee = wdiv(
                sub(_oBal, _feeThreshold),
                wmul(_oWeight, _grossLiq)
            );
            _fee = wmul(_fee, feeDerivative);
            oNAmt_ = wmul(_oNAmt, WAD - _fee);

        } else {
        emit log_uint("ping",0);

            uint256 _fee = wmul(feeDerivative, wdiv(
                sub(_oBal, _feeThreshold),
                wmul(_oWeight, _grossLiq)
            ));
            oNAmt_ = add(
                sub(_feeThreshold, sub(_oBal, _oNAmt)),
                wmul(sub(_oBal, _feeThreshold), WAD - _fee)
            );

        }

        return oNAmt_;

    }

    /// @author James Foley http://github.com/realisation
    /// @notice calculates the fees to apply to the target amount in an origin trade
    /// @param _tWeight the balance weighting of the target flavor
    /// @param _tBal the current balance of the target in the reserve
    /// @param _grossLiq the current total balance across all the reserves in the contract
    /// @return tNAmt_ the target numeraire amount including any applied fees
    function calculateOriginTradeTargetAmount (uint256 _tWeight, uint256 _tBal, uint256 _tNAmt, uint256 _grossLiq) private returns (uint256 tNAmt_) {

        require(sub(_tBal, _tNAmt) >= wmul(_tWeight, wmul(_grossLiq, WAD - alpha)), "origin swap target halt check");

        uint256 _feeThreshold = wmul(_tWeight, wmul(_grossLiq, WAD - beta));
        if (sub(_tBal, _tNAmt) > _feeThreshold) {

            tNAmt_ = wmul(_tNAmt, WAD - feeBase);
            emit log_uint("ping", tNAmt_);

        } else if (_tBal <= _feeThreshold) {

            uint256 _fee = wdiv(
                sub(_feeThreshold, sub(_tBal, _tNAmt)),
                wmul(_tWeight, _grossLiq)
            );
            _fee = wmul(_fee, feeDerivative);
            _tNAmt = wmul(_tNAmt, WAD - _fee);
            tNAmt_ = wmul(_tNAmt, WAD - feeBase);

            emit log_uint("zing", tNAmt_);
        } else {

            uint256 _fee = wmul(feeDerivative, wdiv(
                sub(_feeThreshold, sub(_tBal, _tNAmt)),
                wmul(_tWeight, _grossLiq)
            ));
            tNAmt_ = wmul(add(
                sub(_tBal, _feeThreshold),
                wmul(sub(_feeThreshold, sub(_tBal, _tNAmt)), WAD - _fee)
            ), WAD - feeBase);
            emit log_uint("ring", tNAmt_);

        }

        return tNAmt_;

    }

    /// @author James Foley http://github.com/realisation
    /// @notice given an amount of the target currency this function will derive the corresponding origin amount according to the current state of the contract
    /// @param _origin the address of the origin stablecoin flavor
    /// @param _target the address of the target stablecoin flavor
    /// @param _maxOAmt the highest amount of the origin stablecoin flavor you are willing to trade
    /// @param _tAmt the raw amount of the target stablecoin flavor to be converted into numeraire amount
    /// @param _deadline the block number at which this transaction is no longer valid
    /// @param _recipient the address for where to send the target amount
    function executeTargetTrade (address _origin, address _target, uint256 _maxOAmt, uint256 _tAmt, uint256 _deadline, address _recipient) public returns (uint256) {

        Flavor memory _o = flavors[_origin];
        Flavor memory _t = flavors[_target];

        ( uint256 _oNAmt,
          uint256 _oBal,
          uint256 _tBal,
          uint256 _tNAmt,
          uint256 _grossLiq ) = getTargetTradeVariables(_o, _t, _tAmt) ;

        _oNAmt = calculateTargetTradeTargetAmount(_t.weight, _tBal, _tNAmt, _grossLiq);
        emit log_uint("target", _oNAmt);
        _oNAmt = calculateTargetTradeOriginAmount(_o.weight, _oBal, _oNAmt, _grossLiq);
        emit log_uint("origin", _oNAmt);

        dOutputRaw(_t.adapter, _recipient, _tAmt);
        return dIntakeNumeraire(_o.adapter, _oNAmt);

    }

    /// @author James Foley http://github.com/realisation
    /// @notice builds the relevant variables for the target trade. total liquidity, numeraire amounts and new balances
    /// @param _o the record of the origin flavor containing its adapter and reserve address
    /// @param _t the record of the target flavor containing its adapter and reserve address
    /// @param _tAmt the raw target amount to be converted into numeraire amount
    /// @return tNAmt_ the target numeraire amount
    /// @return tBal_ the new numeraire balance of the target
    /// @return oBal_ the numeraire balance of the origin
    /// @return oNAmt_ empty uint to be filled in as target and origin fees are calculated
    /// @return grossLiq_ the total liquidity in all the reserves of the pool
    function getTargetTradeVariables (Flavor memory _o, Flavor memory _t, uint256 _tAmt) private returns (uint, uint, uint, uint, uint) {

        uint tNAmt_;
        uint tBal_;
        uint oBal_;
        uint oNAmt_;
        uint grossLiq_;

        for (uint i = 0; i < reserves.length; i++) {
            if (reserves[i] == _o.reserve) {
                oBal_ = dGetNumeraireBalance(_o.adapter);
                grossLiq_ += oBal_;
            } else if (reserves[i] == _t.reserve) {
                tNAmt_ = dGetNumeraireAmount(_t.adapter, _tAmt);
                tBal_ = dGetNumeraireBalance(_t.adapter);
                grossLiq_ += tBal_;
                tBal_ = sub(tBal_, tNAmt_);
            } else grossLiq_ += dGetNumeraireBalance(reserves[i]);
        }

        return (oNAmt_, oBal_, tBal_, tNAmt_, grossLiq_);

    }

    /// @author James Foley http://github.com/realisation
    /// @notice this function applies fees to the target amount according to how balanced it is relative to its weight
    /// @param _tWeight the weighted balance point of the target token
    /// @param _tBal the contract's balance of the target
    /// @param _tNAmt the numeraire value of the target amount being traded
    /// @param _grossLiq the total numeraire value of all liquidity across all the reserves of the contract
    /// @return tNAmt_ the target numeraire amount after applying fees
    function calculateTargetTradeTargetAmount(uint256 _tWeight, uint256 _tBal, uint256 _tNAmt, uint256 _grossLiq) public returns (uint256 tNAmt_) {

        require(_tBal >= wmul(_tWeight, wmul(_grossLiq, WAD - alpha)), "target halt check for target trade");

        uint256 _feeThreshold = wmul(_tWeight, wmul(_grossLiq, WAD - beta));
        if (_tBal > _feeThreshold) {

            tNAmt_ = wmul(_tNAmt, WAD + feeBase);

        } else if (add(_tBal, _tNAmt) <= _feeThreshold) {

            uint256 _fee = wdiv(sub(_feeThreshold, _tBal), wmul(_tWeight, _grossLiq));
            _fee = wmul(_fee, feeDerivative);
            _tNAmt = wmul(_tNAmt, WAD + _fee);
            tNAmt_ = wmul(_tNAmt, WAD + feeBase);

        } else {

            uint256 _fee = wmul(feeDerivative, wdiv(
                    sub(_feeThreshold, _tBal),
                    wmul(_tWeight, _grossLiq)
            ));

            _tNAmt = add(
                sub(add(_tBal, _tNAmt), _feeThreshold),
                wmul(sub(_feeThreshold, _tBal), WAD + _fee)
            );

            tNAmt_ = wmul(_tNAmt, WAD + feeBase);

        }

        return tNAmt_;

    }

    /// @author James Foley http://github.com/realisation
    /// @notice this function applies fees to the origin amount according to how balanced it is relative to its weight
    /// @param _oWeight the weighted balance point of the origin token
    /// @param _oBal the contract's balance of the origin
    /// @param _oNAmt the numeraire value for the origin amount being traded
    /// @param _grossLiq the total numeraire value of all liquidity across all the reserves of the contract
    /// @return oNAmt_ the origin numeraire amount after applying fees
    function calculateTargetTradeOriginAmount (uint256 _oWeight, uint256 _oBal, uint256 _oNAmt, uint256 _grossLiq) public returns (uint256 oNAmt_) {

        require(add(_oBal, _oNAmt) <= wmul(_oWeight, wmul(_grossLiq, WAD + alpha)), "origin halt check for target trade");

        uint256 _feeThreshold = wmul(_oWeight, wmul(_grossLiq, WAD + beta));
        if (_oBal + _oNAmt <= _feeThreshold) {

            oNAmt_ = _oNAmt;

        } else if (_oBal >= _feeThreshold) {

            uint256 _fee = wdiv(
                sub(add(_oNAmt, _oBal), _feeThreshold),
                wmul(_oWeight, _grossLiq)
            );
            _fee = wmul(_fee, feeDerivative);
            oNAmt_ = wmul(_oNAmt, WAD + _fee);

        } else {

            uint256 _fee = wmul(feeDerivative, wdiv(
                sub(add(_oBal, _oNAmt), _feeThreshold),
                wmul(_oWeight, _grossLiq)
            ));

            oNAmt_ = add(
                sub(_feeThreshold, _oBal),
                wmul(sub(add(_oBal, _oNAmt), _feeThreshold), WAD + _fee)
            );

        }

        return oNAmt_;

    }

    /// @author James Foley http://github.com/realisation
    /// @dev this function is used in selective deposits and selective withdraws
    /// @dev it finds the reserves corresponding to the flavors and attributes the amounts to these reserves
    /// @param _flavors the addresses of the stablecoin flavor
    /// @param _amounts the specified amount of each stablecoin flavor
    /// @return three arrays each the length of the number of reserves containing the balances, token amounts and weights for each reserve
    function getBalancesTokenAmountsAndWeights (address[] memory _flavors, uint256[] memory _amounts) internal returns (uint256[] memory, uint256[] memory, uint256[] memory) {

        uint256[] memory balances_ = new uint256[](reserves.length);
        uint256[] memory tokenAmounts_ = new uint256[](reserves.length);
        uint256[] memory weights_ = new uint[](reserves.length);

        for (uint i = 0; i < _flavors.length; i++) {
            Flavor memory _f = flavors[_flavors[i]]; // withdrawing adapter + weight
            for (uint j = 0; j < reserves.length; j++) {
                balances_[j] = dGetNumeraireBalance(reserves[j]);
                if (reserves[j] == _f.reserve) {
                    tokenAmounts_[j] += dGetNumeraireAmount(_f.adapter, _amounts[i]);
                    weights_[j] = _f.weight;
                }
            }
        }

        return (balances_, tokenAmounts_, weights_);

    }

    event log_uints(bytes32, uint256[]);

    /// @author James Foley http://github.com/realisation
    /// @notice this function allows selective depositing of any supported stablecoin flavor into the contract in return for corresponding shell tokens
    /// @param _flavors an array containing the addresses of the flavors being deposited into
    /// @param _amounts an array containing the values of the flavors you wish to deposit into the contract. each amount should have the same index as the flavor it is meant to deposit
    /// @return shellsToMint_ the amount of shells to mint for the deposited stablecoin flavors
    function selectiveDeposit (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256 shellsToMint_) {

        ( uint256[] memory _balances,
          uint256[] memory _deposits,
          uint256[] memory _weights ) = getBalancesTokenAmountsAndWeights(_flavors, _amounts);

        shellsToMint_ = calculateShellsToMint(_balances, _deposits, _weights);

        for (uint i = 0; i < _flavors.length; i++) dIntakeNumeraire(flavors[_flavors[i]].adapter, _amounts[i]);

        _mint(msg.sender, shellsToMint_);

        return shellsToMint_;

    }

    /// @notice this function calculates the amount of shells to mint by taking the balances, numeraire deposits and weights of the reserve tokens being deposited into
    /// @dev each array is the same length. each index in each array refers to the same reserve - index 0 is for the reserve token at index 0 in the reserves array, index 1 is for the reserve token at index 1 in the reserve array and so forth.
    /// @param _balances an array of current numeraire balances for each reserve
    /// @param _deposits an array of numeraire amounts to deposit into each reserve
    /// @param _weights an array of the balance weights for each of the reserves
    /// @return shellsToMint_ the amount of shell tokens to mint according to the dynamic fee relative to the balance of each reserve deposited into
    function calculateShellsToMint (uint256[] memory _balances, uint256[] memory _deposits, uint256[] memory _weights) public returns (uint256) {

        uint256 _newSum;
        uint256 _oldSum;
        for (uint i = 0; i < _balances.length; i++) {
            _oldSum = add(_oldSum, _balances[i]);
            _newSum = add(_newSum, add(_balances[i], _deposits[i]));
        }

        emit log_uint("newSum", _newSum);
        emit log_uint("oldSum", _oldSum);

        uint256 shellsToMint_;

        for (uint i = 0; i < _balances.length; i++) {
            if (_deposits[i] == 0) continue;
            uint256 _depositAmount = _deposits[i];
            uint256 _weight = _weights[i];
            uint256 _oldBalance = _balances[i];
            uint256 _newBalance = add(_oldBalance, _depositAmount);


            emit log_uint("newBalance", _newBalance);
            emit log_uint("halt check", wmul(_weight, wmul(_newSum, alpha + WAD)));

            require(_newBalance <= wmul(_weight, wmul(_newSum, alpha + WAD)), "halt check deposit");

            uint256 _feeThreshold = wmul(_weight, wmul(_newSum, beta + WAD));
            if (_newBalance <= _feeThreshold) {

                shellsToMint_ += _depositAmount;

            } else if (_oldBalance > _feeThreshold) {

                uint256 _feePrep = wmul(feeDerivative, wdiv(
                    sub(_newBalance, _feeThreshold),
                    wmul(_weight, _newSum)
                ));

                shellsToMint_ = add(shellsToMint_, wmul(_depositAmount, WAD - _feePrep));

            } else {

                uint256 _feePrep = wmul(feeDerivative, wdiv(
                    sub(_newBalance, _feeThreshold),
                    wmul(_weight, _newSum)
                ));

                shellsToMint_ += add(
                    sub(_feeThreshold, _oldBalance),
                    wmul(sub(_newBalance, _feeThreshold), WAD - _feePrep)
                );

            }
        }

        return wmul(totalSupply(), wdiv(shellsToMint_, _newSum));

    }


    /// @notice this function allows selective the withdrawal of any supported stablecoin flavor from the contract by burning a corresponding amount of shell tokens
    /// @param _flavors an array of flavors to withdraw from the reserves
    /// @param _amounts an array of amounts to withdraw that maps to _flavors
    /// @return shellsBurned_ the corresponding amount of shell tokens to withdraw the specified amount of specified flavors
    function selectiveWithdraw (address[] calldata _flavors, uint256[] calldata _amounts) external returns (uint256 shellsBurned_) {

        ( uint256[] memory _balances,
          uint256[] memory _withdrawals,
          uint256[] memory _weights ) = getBalancesTokenAmountsAndWeights(_flavors, _amounts);

          emit log_uints("balances", _balances);
          emit log_uints("weights", _weights);
          emit log_uints("withdrawals", _withdrawals);

        shellsBurned_ = calculateShellsToBurn(_balances, _withdrawals, _weights);

        for (uint i = 0; i < _flavors.length; i++) dOutputRaw(flavors[_flavors[i]].adapter, msg.sender, _amounts[i]);

        _burn(msg.sender, shellsBurned_);

        return shellsBurned_;

    }

    /// @notice this function calculates the amount of shells to mint by taking the balances, numeraire deposits and weights of the reserve tokens being deposited into
    /// @dev each array is the same length. each index in each array refers to the same reserve - index 0 is for the reserve token at index 0 in the reserves array, index 1 is for the reserve token at index 1 in the reserve array and so forth.
    /// @param _balances an array of current numeraire balances for each reserve
    /// @param _withdrawals an array of numeraire amounts to deposit into each reserve
    /// @param _weights an array of the balance weights for each of the reserves
    /// @return shellsToBurn_ the amount of shell tokens to burn according to the dynamic fee of each withdraw relative to the balance of each reserve
    function calculateShellsToBurn (uint256[] memory _balances, uint256[] memory _withdrawals, uint256[] memory _weights) internal returns (uint256) {

        uint256 _newSum;
        uint256 _oldSum;
        for (uint i = 0; i < _balances.length; i++) {
            _oldSum = add(_oldSum, _balances[i]);
            _newSum = add(_newSum, sub(_balances[i], _withdrawals[i]));
        }

        emit log_uint("oldSum", _oldSum);
        emit log_uint("newSum", _newSum);

        uint256 _numeraireShellsToBurn;

        for (uint i = 0; i < reserves.length; i++) {
            if (_withdrawals[i] == 0) continue;
            uint256 _withdrawal = _withdrawals[i];
            uint256 _weight = _weights[i];
            uint256 _oldBal = _balances[i];
            uint256 _newBal = sub(_oldBal, _withdrawal);

            require(_newBal >= wmul(_weight, wmul(_newSum, WAD - alpha)), "withdraw halt check");

            uint256 _feeThreshold = wmul(_weight, wmul(_newSum, WAD - beta));

            if (_newBal >= _feeThreshold) {

                uint256 newShellsToBurn = wmul(_withdrawal, WAD + feeBase);

                emit log_uint("newShellsToBurn", newShellsToBurn);

                _numeraireShellsToBurn += newShellsToBurn;

            } else if (_oldBal < _feeThreshold) {

                uint256 _feePrep = wdiv(sub(_feeThreshold, _newBal), wmul(_weight, _newSum));

                _feePrep = wmul(_feePrep, feeDerivative);

                uint256 newShellsToBurn = wmul(wmul(_withdrawal, WAD + _feePrep), WAD + feeBase);

                _numeraireShellsToBurn += newShellsToBurn;

            } else {

                uint256 _feePrep = wdiv(sub(_feeThreshold, _newBal), wmul(_weight, _newSum));

                _feePrep = wmul(feeDerivative, _feePrep);

                uint256 newShellsToBurn = wmul(add(
                    sub(_oldBal, _feeThreshold),
                    wmul(sub(_feeThreshold, _newBal), WAD + _feePrep)
                ), WAD + feeBase);

                _numeraireShellsToBurn += newShellsToBurn;

            }
        }

        return wmul(totalSupply(), wdiv(_numeraireShellsToBurn, _newSum));

    }

    function proportionalDeposit (uint256 totalDeposit) public returns (uint256) {

        uint256 totalBalance;
        uint256 _totalSupply = totalSupply();

        uint256[] memory amounts = new uint256[](3);

        for (uint i = 0; i < reserves.length; i++) {
            uint256 numeBalance = dGetNumeraireBalance(reserves[i]);
            emit log_uint("numebal", numeBalance);
            emit log_address("nuemraries[i]", numeraires[i]);
            totalBalance += numeBalance;
            Flavor memory d = flavors[numeraires[i]];
            amounts[i] = wmul(d.weight, totalDeposit);
        }

        if (totalBalance == 0) {
            totalBalance = WAD;
            _totalSupply = WAD;
        }

        uint256 newShells = wmul(totalDeposit, wdiv(totalBalance, _totalSupply));
        _mint(msg.sender, newShells);

        for (uint i = 0; i < reserves.length; i++ ) {
            Flavor memory d = flavors[numeraires[i]];
            dIntakeNumeraire(d.adapter, amounts[i]);
        }

        return newShells;

    }


    function proportionalWithdraw (uint256 totalWithdrawal) public returns (uint256[] memory) {

        uint256[] memory withdrawalAmounts = new uint256[](reserves.length);
        uint256 shellsToBurn = wmul(totalWithdrawal, WAD + feeBase);

        uint256 oldTotal;
        for (uint i = 0; i < reserves.length; i++) {
            withdrawalAmounts[i] = dGetNumeraireBalance(reserves[i]);
            oldTotal += withdrawalAmounts[i];
        }


        for (uint i = 0; i < reserves.length; i++) {
            Flavor storage w = flavors[numeraires[i]];
            uint256 numeraireToWithdraw = wmul(totalWithdrawal, wdiv(withdrawalAmounts[i], oldTotal));
            // uint256 numeraireToWithdraw = wdiv(withdrawalAmounts[i], wmul(oldTotal, totalWithdrawal));
            uint256 amountWithdrawn = dOutputNumeraire(w.adapter, msg.sender, numeraireToWithdraw);
            withdrawalAmounts[i] = amountWithdrawn;
        }


        _burnFrom(msg.sender, shellsToBurn);
        return withdrawalAmounts;

    }


}