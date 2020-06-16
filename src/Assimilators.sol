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
        // uint ix;
        // int128 amt;
        // int128 bal;
    }

    // function flip (Assimilator memory _assim) internal view {

    //     _assim.amt = _assim.amt.neg();

    // }

    // function viewRawAmount (Assimilator memory _assim) internal returns (uint256 amount_) {

    //     // amount_ = IAssimilator(_assim.addr).viewRawAmount(_assim.amt);

    //     bytes memory data = abi.encodeWithSelector(iAsmltr.viewRawAmount.selector, _assim.amt);

    //     amount_ = abi.decode(_assim.addr.delegate(data), (uint256));

    // }

    // function viewNumeraireAmount (Assimilator memory _assim, uint256 _amt) internal {

    //     // amount_ = IAssimilator(_assim.addr).viewNumeraireAmount(_amt);

    //     bytes memory data = abi.encodeWithSelector(iAsmltr.viewNumeraireAmount.selector, _amt);

    //     _assim.amt = abi.decode(_assim.addr.delegate(data), (int128));

    // }

    event log_addr(bytes32, address);

    function viewNumeraireBalance (Assimilator memory _assim) internal returns (int128 nAmt_) {

        // nAmt_ = IAssimilator(_assim.addr).viewNumeraireBalance(address(this));

        bytes memory data = abi.encodeWithSelector(iAsmltr.viewNumeraireBalance.selector, address(this));

        nAmt_ = abi.decode(_assim.addr.delegate(data), (int128));

    }

    // function viewNumeraireBalance (Assimilator memory _assim, int128 _amt) internal {

    //     bytes memory data = abi.encodeWithSelector(iAsmltr.viewNumeraireBalance.selector, address(this));

    //     _assim.amt = _amt.neg();

    //     _assim.bal = abi.decode(_assim.addr.delegate(data), (int128));

    //     _assim.bal = _assim.bal.add(_assim.amt);


    // }

    // function intakeRaw (Assimilator memory _assim, uint256 _amount) internal {

    //     bytes memory data = abi.encodeWithSelector(iAsmltr.intakeRaw.selector, _amount); // encoded selector of "intakeRaw(uint256)";

    //     ( _assim.amt, _assim.bal ) = abi.decode(_assim.addr.delegate(data), (int128,int128));

    // }

    function intakeRaw (Assimilator memory _assim, uint256 _amount) internal returns (int128 amt_, int128 bal_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.intakeRaw.selector, _amount); // encoded selector of "intakeRaw(uint256)";

        ( amt_, bal_ ) = abi.decode(_assim.addr.delegate(data), (int128,int128));

    }

    // function intakeNumeraire (Assimilator memory _assim) internal returns (uint256 rawAmt_) {

    //     rawAmt_ = intakeNumeraire(_assim, _assim.amt);

    // }

    // function intakeNumeraire (Assimilator memory _assim, int128 _amt) internal returns (uint256 rawAmt_) {

    //     rawAmt_ = intakeNumeraire(_assim, _amt);

    // }

    function intakeNumeraire (Assimilator memory _assim, int128 _amt) internal returns (uint256 rawAmt_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.intakeNumeraire.selector, _amt);

        rawAmt_ = abi.decode(_assim.addr.delegate(data), (uint256));

    }

    function outputRaw (Assimilator memory _assim, address _dst, uint256 _amount) internal returns (int128 amt_, int128 bal_) {
        
        emit log_uint("_amount", _amount);
        emit log_addr("_dst", _dst);

        bytes memory data = abi.encodeWithSelector(iAsmltr.outputRaw.selector, _dst, _amount);

        ( amt_, bal_ ) = abi.decode(_assim.addr.delegate(data), (int128,int128));

        amt_ = amt_.neg();

    }

    // function outputRaw (Assimilator memory _assim, address _dst, uint256 _amount) internal returns (int128 amt_, int128 bal_) {

    //     emit log_uint("_amount", _amount);
    //     emit log_addr("_dst", _dst);

    //     bytes memory data = abi.encodeWithSelector(iAsmltr.outputRaw.selector, _dst, _amount);

    //     ( amt_, bal_ ) = abi.decode(_assim.addr.delegate(data), (int128,int128));

    //     amt_ = amt_.neg();

    // }

    event log(bytes32);

    // function outputRawHack (Assimilator memory _assim, address _dst, uint256 _amount) internal returns (int128, int128) {

    //     emit log("output raw hack");
    //     emit log_uint("_amount", _amount);
    //     emit log_addr("_dst", _dst);

    //     bytes memory data = abi.encodeWithSelector(iAsmltr.outputRaw.selector, _dst, _amount);
    //     emit log("raw hack");

    //     ( int128 amt_, int128 bal_ ) = abi.decode(_assim.addr.delegate(data), (int128,int128));

    //     emit log("hack");

    //     amt_ = amt_.neg();

    //     return (amt_, bal_);

    // }

    event log_uint(bytes32, uint256);
    event log_int(bytes32, int256);

    function outputNumeraireHack (Assimilator memory _assim, address _dst, int128 _amt) internal returns (uint256 rawAmt_) {

        // emit log_uint("Raw Amount", rawAmt_);

        // emit log_int("_amt", _amt.muli(1e18));

        rawAmt_ = outputNumeraire(_assim, _dst, _amt.abs());

        // emit log_uint("Raw Amount", rawAmt_);

    }

    // function outputNumeraire (Assimilator memory _assim, address _dst) internal returns (uint256 rawAmt_) {

    //     rawAmt_ = outputNumeraire(_assim, _dst, _assim.amt.abs());

    // }

    function outputNumeraire (Assimilator memory _assim, address _dst, int128 _amt) internal returns (uint256 rawAmt_) {

        bytes memory data = abi.encodeWithSelector(iAsmltr.outputNumeraire.selector, _dst, _amt.abs());

        rawAmt_ = abi.decode(_assim.addr.delegate(data), (uint256));

    }

}