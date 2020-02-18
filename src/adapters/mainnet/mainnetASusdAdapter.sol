pragma solidity ^0.5.12;

import "../../IAToken.sol";
import "../aaveResources/ILendingPoolAddressesProvider.sol";
import "../aaveResources/ILendingPool.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract MainnetASusdAdapter {

    // address constant susd = 0x57Ab1E02fEE23774580C119740129eAC7081e9D3;
    address constant susd = 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51;
    address constant asusd = 0x625aE63000f46200499120B906716420bd059240;
    ILendingPoolAddressesProvider constant lpProvider = ILendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8);

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
            uint40 lastUpdateTimestamp ) = pool.getReserveData(susd);

            emit log_addr("aTokenAddress", aTokenAddress);
            emit log_addr("asusd", asusd);
            emit log_uint("avail liq", availableLiquidity);




    }

    // takes raw cdai amount
    // unwraps it into dai
    // deposits dai amount in chai
    function intakeRaw (uint256 amount) public {
        IAToken(asusd).transferFrom(msg.sender, address(this), amount);
    }

    function intakeNumeraire (uint256 amount) public returns (uint256) {
        amount /= 1000000000000;
        IAToken(asusd).transferFrom(msg.sender, address(this), amount);
        return amount;
    }

    function outputRaw (address dst, uint256 amount) public {
        IAToken(asusd).transfer(dst, amount);
    }

    // unwraps numeraire amount of dai from chai
    // wraps it into cdai amount
    // sends that to destination
    function outputNumeraire (address dst, uint256 amount) public returns (uint256) {
        amount /= 1000000000000;
        IAToken(asusd).transfer(dst, amount);
        return amount;
    }

    function viewRawAmount (uint256 amount) public view returns (uint256) {
        return amount / 1000000000000;
    }

    function viewNumeraireAmount (uint256 amount) public view returns (uint256) {
        return amount * 1000000000000;
    }

    function viewNumeraireBalance (address addr) public view returns (uint256) {
        return IAToken(asusd).balanceOf(address(this));
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
        return IAToken(asusd).balanceOf(address(this));
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