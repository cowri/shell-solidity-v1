pragma solidity ^0.5.12;

import "../../IAToken.sol";
import "../aaveResources/ILendingPoolAddressesProvider.sol";
import "../aaveResources/ILendingPool.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract KovanAUsdtAdapter {

    address constant usdt = 0x13512979ADE267AB5100878E2e0f485B568328a4;
    address constant ausdt = 0xA01bA9fB493b851F4Ac5093A324CB081A909C34B;
    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5);

    event log_addr(bytes32, address);
    event log_uint(bytes32, uint256);

    constructor () public { }

    function getData () public {
        ILendingPool pool = ILendingPool(lpProvider.getLendingPool());
        emit log_addr("pool", address(pool));
        
        (   uint256 totalLiquidity,
            uint256 availableLiquidity,
            uint256 totalBorrowsStable,
            uint256 totalBorrowsVariable,
            uint256 liquidityRate,
            uint256 variableBorrowRate,
            uint256 stableBorrowRate,
            uint256 averageStableBorrowRate,
            uint256 utilizationRate,
            uint256 liquidityIndex,
            uint256 variableBorrowIndex,
            address aTokenAddress,
            uint40 lastUpdateTimestamp ) = pool.getReserveData(usdt);

            emit log_addr("aTokenAddress", aTokenAddress);
            emit log_addr("ausdt", ausdt);
            emit log_uint("avail liq", availableLiquidity);


    }

    // takes raw cdai amount
    // unwraps it into dai
    // deposits dai amount in chai
    function intakeRaw (uint256 amount) public {
        IAToken(ausdt).transferFrom(msg.sender, address(this), amount);
    }

    function intakeNumeraire (uint256 amount) public returns (uint256) {
        amount /= 1000000000000;
        IAToken(ausdt).transferFrom(msg.sender, address(this), amount);
        return amount;
    }

    function outputRaw (address dst, uint256 amount) public {
        IAToken(ausdt).transfer(dst, amount);
    }

    // unwraps numeraire amount of dai from chai
    // wraps it into cdai amount
    // sends that to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        amount /= 1000000000000;
        IAToken(ausdt).transfer(dst, amount);
        return amount;
    }

    function viewRawAmount (uint256 amount) public view returns (uint256) {
        return amount / 1000000000000;
    }

    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {
        return amount * 1000000000000;
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        return IAToken(ausdt).balanceOf(address(addr));
    }

    // takes raw amount and gives numeraire amount
    function getRawAmount (uint256 amount) public returns (uint256) {
        return amount / 1000000000000;
    }

    // takes raw amount and gives numeraire amount
    function getNumeraireAmount (uint256 amount) public returns (uint256) {
        return amount * 1000000000000;
    }

    function getNumeraireBalance () public returns (uint256) {
        return IAToken(ausdt).balanceOf(address(this));
    }

    uint constant WAD = 10 ** 18;
    
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD) / WAD;
    }

    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function wdivup(uint x, uint y) internal pure returns (uint z) {
        // always rounds up
        z = add(mul(x, WAD), sub(y, 1)) / y;
    }


}