// pragma solidity ^0.5.0;

// import "./FlavorLibrary.sol";

// contract FlavorBrain {
//     mapping (address => FL.Flavor) public flavors;
//     using FL for FL.Flavor;
//     event log_address(bytes32, address);

//     function includeFlavor (address flavor, address adapter, address reserve, uint256 weight) public {
//         FL.Flavor memory f = FL.Flavor(adapter, reserve, weight);
//         flavors[flavor] = f;
//     }

//     function viewBalance (address flavor) public returns (uint256) {
//         FL.Flavor storage f = flavors[flavor];
//         emit log_address("me in contract", address(this));
//         uint256 bal = f.dViewNumeraireBalance();
//         return bal;
//     }

//     function viewBalNest (address flavor) public returns (uint256) {
//         return IL.logger(flavor);
//     }
// }