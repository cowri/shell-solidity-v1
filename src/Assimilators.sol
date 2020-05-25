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

import "./interfaces/IAdapter.sol";
import "abdk-libraries-solidity/ABDKMath64x64.sol";

pragma solidity >0.4.13;

library Delegate {

    function delegate(address _callee, bytes memory _data) internal returns (bytes memory) {

        (bool _success, bytes memory returnData_) = _callee.delegatecall(_data);

        assembly { if eq(_success, 0) { revert(add(returnData_, 0x20), returndatasize()) } }

        return returnData_;

    }

}

library Assimilators {

    using Delegate for address;
    using ABDKMath64x64 for int128;
    IAdapter constant iAdptr = IAdapter(address(0));

    struct Assimilator {
        address addr;
        uint256 ix;
        int128 amt;
    }

    function flip (Assimilator memory _assim) internal view {

        _assim.amt = _assim.amt.neg();

    }

    function viewRawAmount (Assimilator memory _assim) internal view returns (uint256 amount_) {

        amount_ = IAdapter(_assim.addr).viewRawAmount(_assim.amt);

    }

    function viewNumeraireAmount (Assimilator memory _assim, uint256 _amt) internal view {

        _assim.amt = IAdapter(_assim.addr).viewNumeraireAmount(_amt);

    }

    function viewNumeraireBalance (Assimilator memory _assim) internal view returns (int128) {

        return IAdapter(_assim.addr).viewNumeraireBalance(address(this));

    }

    function intakeRaw (Assimilator memory _assim, uint256 amount) internal {

        bytes memory data = abi.encodeWithSelector(iAdptr.intakeRaw.selector, amount); // encoded selector of "intakeRaw(uint256)";

        _assim.amt = abi.decode(_assim.addr.delegate(data), (int128));

    }

    function intakeNumeraire (Assimilator memory _assim) internal returns (uint256) {

        return intakeNumeraire(_assim, _assim.amt);

    }

    function intakeNumeraire (Assimilator memory _assim, int128 _amt) internal returns (uint256) {

        bytes memory data = abi.encodeWithSelector(iAdptr.intakeNumeraire.selector, _amt);

        return abi.decode(_assim.addr.delegate(data), (uint256));

    }

    function outputRaw (Assimilator memory _assim, address _dst, uint256 _amount) internal {

        bytes memory data = abi.encodeWithSelector(iAdptr.outputRaw.selector, _dst, _amount);

        _assim.amt = abi.decode(_assim.addr.delegate(data), (int128));

    }

    function outputNumeraire (Assimilator memory _assim, address _dst) internal returns (uint256) {

        return outputNumeraire(_assim, _dst, _assim.amt);

    }

    function outputNumeraire (Assimilator memory _assim, address _dst, int128 _amt) internal returns (uint256) {

        bytes memory data = abi.encodeWithSelector(iAdptr.outputNumeraire.selector, _dst, _amt);

        return abi.decode(_assim.addr.delegate(data), (uint256));

    }

}