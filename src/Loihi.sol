pragma solidity ^0.5.0;

import "./LoihiRoot.sol";

contract Loihi is LoihiRoot {

    constructor () public {
        owner = msg.sender;
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

    function viewOriginTrade (address _o, address _t, uint256 _amt) public view returns (uint256) {
        (bool success, bytes memory result) = exchange.staticcall(abi.encodeWithSelector(0x6980ae1e, address(this), _o, _t, _amt));
        require(success, "view origin trade failed");
        return abi.decode(result, (uint256));
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
    
    function viewTargetTrade (address _o, address _t, uint256 _amt) public view returns (uint256) {
        (bool success, bytes memory result) = exchange.staticcall(abi.encodeWithSelector(0x52f151f3, address(this), _o, _t, _amt));
        require(success, "view origin trade failed");
        return abi.decode(result, (uint256));
    }

    function selectiveDeposit (address[] calldata _flvrs, uint256[] calldata _amts, uint256 _minShells, uint256 _dline) external returns (uint256) {
        (bool success, bytes memory result) = liquidity.delegatecall(abi.encodeWithSelector(0x51dbb2a7, _flvrs, _amts, _minShells, _dline));
        require(success, "selective deposit failed");
        return abi.decode(result, (uint256));

    }

    event log_address(bytes32, address);

    function proportionalDeposit (uint256 _total) external returns (uint256) {
        emit log_address("liquidity", liquidity);
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

}