
// pragma solidity ^0.5.12;



// library FL {
//     struct Flavor { address adapter; address reserve; uint256 weight; }
//     event log_address(bytes32, address);

//     // function dViewRawAmount (address addr, uint256 amount) internal view returns (uint256) {
//     //     (bool success, bytes memory result) = addr.staticcall(abi.encodeWithSelector(0x049ca270, amount)); // encoded selector of "getNumeraireAmount(uint256");
//     //     assert(success);
//     //     return abi.decode(result, (uint256));
//     // }

//     // function dViewNumeraireAmount (address addr, uint256 amount) internal view returns (uint256) {
//     //     (bool success, bytes memory result) = addr.staticcall(abi.encodeWithSelector(0xf5e6c0ca, amount)); // encoded selector of "getNumeraireAmount(uint256");
//     //     assert(success);
//     //     return abi.decode(result, (uint256));
//     // }

//     function dViewNumeraireBalance (Flavor memory flavor) internal returns (uint256) {
//         (bool success, bytes memory result) = flavor.adapter.staticcall(abi.encodeWithSelector(0xac969a73, address(this))); // encoded selector of "getNumeraireAmount(uint256");
//         emit log_address("me from library", address(this));
//         assert(success);
//         uint256 bal = abi.decode(result, (uint256));
//         emit log_uint("bal from lib", bal);
//         return bal;
//     }

//     event log_uint(bytes32, uint256);
//     // function dGetNumeraireAmount (address addr, uint256 amount) internal returns (uint256) {
//     //     (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xb2e87f0f, amount)); // encoded selector of "getNumeraireAmount(uint256");
//     //     assert(success);
//     //     return abi.decode(result, (uint256));
//     // }

//     // function dGetNumeraireBalance (address addr) internal returns (uint256) {
//     //     (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0x10df6430)); // encoded selector of "getNumeraireBalance()";
//     //     assert(success);
//     //     return abi.decode(result, (uint256));
//     // }

//     // function dIntakeRaw (address addr, uint256 amount) internal {
//     //     (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xfa00102a, amount)); // encoded selector of "intakeRaw(uint256)";
//     //     assert(success);
//     // }

//     // function dIntakeNumeraire (address addr, uint256 amount) internal returns (uint256) {
//     //     (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0x7695ab51, amount)); // encoded selector of "intakeNumeraire(uint256)";
//     //     assert(success);
//     //     return abi.decode(result, (uint256));
//     // }

//     // function dOutputRaw (address addr, address dst, uint256 amount) internal {
//     //     (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xf09a3fc3, dst, amount)); // encoded selector of "outputRaw(address,uint256)";
//     //     assert(success);
//     // }

//     // function dOutputNumeraire (address addr, address dst, uint256 amount) internal returns (uint256) {
//     //     (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xef40df22, dst, amount)); // encoded selector of "outputNumeraire(address,uint256)";
//     //     assert(success);
//     //     return abi.decode(result, (uint256));
//     // }
// }