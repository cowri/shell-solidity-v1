pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/ownership/Ownable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Burnable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Detailed.sol";
import "ds-math/math.sol";

contract LoihiRoot is ERC20, ERC20Mintable, ERC20Burnable, DSMath, Ownable {

    mapping(address => Flavor) public flavors;
    address[] public reserves;
    address[] public numeraires;
    struct Flavor { address adapter; address reserve; uint256 weight; }

    uint256 alpha = 950000000000000000; // 95%
    uint256 beta = 475000000000000000; // half of 95%
    uint256 feeBase = 500000000000000; // 5 bps
    uint256 feeDerivative = 52631578940000000; // marginal fee will be 5% at alpha point

    bytes4 constant internal ERC20ID = 0x36372b07;
    bytes4 constant internal ERC165ID = 0x01ffc9a7;

    function supportsInterface (bytes4 interfaceID) external view returns (bool) {
        return interfaceID == ERC20ID
            || interfaceID == ERC165ID;
    }

}