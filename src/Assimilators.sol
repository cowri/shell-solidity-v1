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

import "./interfaces/IAssimilator.sol";
import "abdk-libraries-solidity/ABDKMath64x64.sol";

pragma solidity >0.4.13;

library Delegate {

    event log_addr(bytes32, address);
    event log_bytes(bytes32, bytes);

    function delegate(address _callee, bytes memory _data) internal returns (bytes memory) {

        (bool _success, bytes memory returnData_) = _callee.delegatecall(_data);

        assembly { if eq(_success, 0) { revert(add(returnData_, 0x20), returndatasize()) } }

        return returnData_;

    }

}

library Assimilators {

    using Delegate for address;
    using ABDKMath64x64 for int128;
    IAssimilator constant iAsmltr = IAssimilator(address(0));

    struct Assimilator {
        address addr;
        uint8 ix;
    }

    function viewRawAmount (Assimilator memory _assim, int128 _amt) internal returns (uint256 amount_) {

        // amount_ = IAssimilator(_assim.addr).viewRawAmount(_amt);

        bytes memory data = abi.encodeWithSelector(iAsmltr.viewRawAmount.selector, _amt);

        amount_ = abi.decode(_assim.addr.delegate(data), (uint256));

    }

    function viewNumeraireAmount (Assimilator memory _assim, uint256 _amt) internal returns (int128 amt_) {

        // amount_ = IAssimilator(_assim.addr).viewNumeraireAmount(_amt);

        bytes memory data = abi.encodeWithSelector(iAsmltr.viewNumeraireAmount.selector, _amt);

        amt_ = abi.decode(_assim.addr.delegate(data), (int128));

    }

    function viewNumeraireAmountAndBalance (Assimilator memory _assim, uint256 _amt) internal returns (int128 amt_, int128 bal_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.viewNumeraireAmount.selector, _amt);

        ( bal_, amt_ ) = abi.decode(_assim.addr.delegate(data), (int128));

    }

    function viewNumeraireBalance (Assimilator memory _assim) internal returns (int128 bal_) {

        // nAmt_ = IAssimilator(_assim.addr).viewNumeraireBalance(address(this));

        bytes memory data = abi.encodeWithSelector(iAsmltr.viewNumeraireBalance.selector, address(this));

        bal_ = abi.decode(_assim.addr.delegate(data), (int128));

    }

    function intakeRaw (Assimilator memory _assim, uint256 _amount) internal returns (int128 amt_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.intakeRawAndGetBalance.selector, _amount); // encoded selector of "intakeRaw(uint256)";

        amt_ = abi.decode(_assim.addr.delegate(data), (int128,int128));

    }

    function intakeRawAndGetBalance (Assimilator memory _assim, uint256 _amount) internal returns (int128 amt_, int128 bal_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.intakeRawAndGetBalance.selector, _amount); // encoded selector of "intakeRaw(uint256)";

        ( amt_, bal_ ) = abi.decode(_assim.addr.delegate(data), (int128,int128));

    }

    function intakeNumeraire (Assimilator memory _assim, int128 _amt) internal returns (uint256 rawAmt_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.intakeNumeraire.selector, _amt);

        rawAmt_ = abi.decode(_assim.addr.delegate(data), (uint256));

    }

    function outputRaw (Assimilator memory _assim, address _dst, uint256 _amount) internal returns (int128 amt_ ) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.outputRaw.selector, _dst, _amount);

        amt_ = abi.decode(_assim.addr.delegate(data), (int128,int128));

        amt_ = amt_.neg();

    }

    function outputRawAndGetBalance (Assimilator memory _assim, address _dst, uint256 _amount) internal returns (int128 amt_, int128 bal_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.outputRawAndGetBalance.selector, _dst, _amount);

        ( amt_, bal_ ) = abi.decode(_assim.addr.delegate(data), (int128,int128));

        amt_ = amt_.neg();

    }

    event log(bytes32);
    event log_uint(bytes32, uint256);
    event log_int(bytes32, int256);

    function outputNumeraire (Assimilator memory _assim, address _dst, int128 _amt) internal returns (uint256 rawAmt_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.outputNumeraire.selector, _dst, _amt.abs());

        rawAmt_ = abi.decode(_assim.addr.delegate(data), (uint256));

    }

}