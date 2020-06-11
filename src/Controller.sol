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

pragma solidity >0.4.13;

import "./Assimilators.sol";
import "./Shells.sol";
import "abdk-libraries-solidity/ABDKMath64x64.sol";

library Controller {

    int128 constant ONE = 0x10000000000000000;

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    using Assimilators for Assimilators.Assimilator;

    using Shells for Shells.Shell;

    event log(bytes32);
    event log_int(bytes32, int128);
    event log_int(bytes32, int);
    event log_uint(bytes32, uint);
    event log_addr(bytes32, address);

    function setParams (Shells.Shell storage shell, uint256 _alpha, uint256 _beta, uint256 _max, uint256 _epsilon, uint256 _lambda, uint256 _omega) internal {

        shell.max = _max.divu(1e18);

        shell.alpha = _alpha.divu(1e18);

        shell.beta = _beta.divu(1e18);
        shell.delta = shell.max.div(uint256(2).fromUInt().mul(shell.alpha.sub(shell.beta)));
        shell.epsilon = _epsilon.divu(1e18);
        shell.lambda = _lambda.divu(1e18);

        require(shell.alpha < ONE && shell.alpha > 0, "Shell/parameter-invalid-alpha");
        require(shell.beta < shell.alpha && shell.beta > 0, "Shell/parameter-invalid-beta");
        require(shell.epsilon > 0 && _epsilon < 1e16, "Shell/parameter-invalid-epsilon");

        require(shell.max <= ONE.div(uint256(2).fromUInt()), "Shell/parameter-invalid-max-fee");

        // emit log_uint("shell.weights.length", shell.weights.length);
        // int128 _totalBalance;
        // for (uint i = 0; i < shell.weights.length; i++) {
        //     _totalBalance += shell.reserves[i].viewNumeraireBalance();
        // }

        shell.omega = 0;
        for (uint i = 0; i < shell.weights.length; i++) {
            // int128 _ideal = _totalBalance.mul(shell.weights[i]);
            // int128 _bal = shell.reserves[i].viewNumeraireBalance();
            // require(_bal > _ideal.mul(ONE.sub(shell.alpha)), "Shell/parameter-lower-halt-check");
            // require(_bal < _ideal.mul(ONE.add(shell.alpha)), "Shell/parameter-upper-halt-check");
            // require(ONE > shell.weights[i].mul(ONE.add(shell.alpha)), "Shell/parameter-alpha-check-failed");
            // shell.omega += Shells.calculateMicroFee(_bal, _ideal, shell.beta, shell.delta);
        }

    }

    function includeAsset (Shells.Shell storage shell, address _numeraire, address _numeraireAssim, address _reserve, address _reserveAssim, uint256 _weight) internal {

        Assimilators.Assimilator storage _numeraireAssimilator = shell.assimilators[_numeraire];

        _numeraireAssimilator.addr = _numeraireAssim;

        _numeraireAssimilator.ix = shell.numeraires.length;

        shell.numeraires.push(_numeraireAssimilator);

        Assimilators.Assimilator storage _reserveAssimilator = shell.assimilators[_reserve];

        _reserveAssimilator.addr = _reserveAssim;

        _reserveAssimilator.ix = shell.reserves.length;

        shell.reserves.push(_reserveAssimilator);

        shell.weights.push(_weight.divu(1e18).add(uint256(1).divu(1e18)));

    }

    function includeAssimilator (Shells.Shell storage shell, address _numeraire, address _derivative, address _assimilator) internal {

        Assimilators.Assimilator storage _numeraireAssim = shell.assimilators[_numeraire];

        shell.assimilators[_derivative] = Assimilators.Assimilator(_assimilator, _numeraireAssim.ix, 0, 0);

    }

}