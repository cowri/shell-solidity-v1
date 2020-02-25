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

contract LoihiDelegators {

    function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
        (bool success, bytes memory returnData) = callee.delegatecall(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
        return returnData;
    }

    function staticTo(address callee, bytes memory data) internal view returns (bytes memory) {
        (bool success, bytes memory returnData) = callee.staticcall(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
        return returnData;
    }


    function dViewRawAmount (address addr, uint256 amount) internal view returns (uint256) {
        bytes memory result = staticTo(addr, abi.encodeWithSelector(0x049ca270, amount)); // encoded selector of "getNumeraireAmount(uint256");
        return abi.decode(result, (uint256));
    }

    function dViewNumeraireAmount (address addr, uint256 amount) internal view returns (uint256) {
        bytes memory result = staticTo(addr, abi.encodeWithSelector(0xf5e6c0ca, amount)); // encoded selector of "getNumeraireAmount(uint256");
        return abi.decode(result, (uint256));
    }

    function dViewNumeraireBalance (address addr, address _this) internal view returns (uint256) {
        bytes memory result = staticTo(addr, abi.encodeWithSelector(0xac969a73, _this)); // encoded selector of "getNumeraireAmount(uint256");
        return abi.decode(result, (uint256));
    }

    function dGetNumeraireAmount (address addr, uint256 amount) internal returns (uint256) {
        bytes memory result = delegateTo(addr, abi.encodeWithSelector(0xb2e87f0f, amount)); // encoded selector of "getNumeraireAmount(uint256");
        return abi.decode(result, (uint256));
    }

    function dGetNumeraireBalance (address addr) internal returns (uint256) {
        bytes memory result = delegateTo(addr, abi.encodeWithSelector(0x10df6430)); // encoded selector of "getNumeraireBalance()";
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @dev this function delegate calls addr, which is an interface to the required functions for retrieving and transfering numeraire and raw values and vice versa
    /// @param addr the address to the interface wrapper to be delegatecall'd
    /// @param amount the numeraire amount to be transfered into the contract. will be adjusted to the raw amount before transfer
    function dIntakeRaw (address addr, uint256 amount) internal {
        bytes memory result = delegateTo(addr, abi.encodeWithSelector(0xfa00102a, amount)); // encoded selector of "intakeRaw(uint256)";
    }

    /// @author james foley http://github.com/realisation
    /// @dev this function delegate calls addr, which is an interface to the required functions for retrieving and transfering numeraire and raw values and vice versa
    /// @param addr the address to the interface wrapper to be delegatecall'd
    /// @param amount the numeraire amount to be transfered into the contract. will be adjusted to the raw amount before transfer
    function dIntakeNumeraire (address addr, uint256 amount) internal returns (uint256) {
        bytes memory result = delegateTo(addr, abi.encodeWithSelector(0x7695ab51, amount)); // encoded selector of "intakeNumeraire(uint256)";
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @dev this function delegate calls addr, which is an interface to the required functions for retrieving and transfering numeraire and raw values and vice versa
    /// @param addr the address of the interface wrapper to be delegatecall'd
    /// @param dst the destination to which to send the raw amount
    /// @param amount the raw amount of the asset to send
    function dOutputRaw (address addr, address dst, uint256 amount) internal {
        bytes memory result = delegateTo(addr, abi.encodeWithSelector(0xf09a3fc3, dst, amount)); // encoded selector of "outputRaw(address,uint256)";
    }

    /// @author james foley http://github.com/realisation
    /// @dev this function delegate calls addr, which is an interface to the required functions to retrieve the numeraire and raw values and vice versa
    /// @param addr address of the interface wrapper
    /// @param dst the destination to send the raw amount to
    /// @param amount the numeraire amount of the asset to be sent. this will be adjusted to the corresponding raw amount
    /// @return the raw amount of the asset that was transfered
    function dOutputNumeraire (address addr, address dst, uint256 amount) internal returns (uint256) {
        bytes memory result = delegateTo(addr, abi.encodeWithSelector(0xef40df22, dst, amount)); // encoded selector of "outputNumeraire(address,uint256)";
        return abi.decode(result, (uint256));
    }
}