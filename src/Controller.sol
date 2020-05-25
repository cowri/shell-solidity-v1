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

    int128 constant ZEN = 18446744073709551616000000;

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    using Assimilators for Assimilators.Assimilator;

    using Shells for Shells.Shell;

    function setParams (Shells.Shell storage shell, uint256 __alpha, uint256 __beta, uint256 __epsilon, uint256 __max, uint256 __lambda, uint256 __omega) external {
        int128 _alpha = __alpha.fromUInt();
        int128 _beta = __beta.fromUInt();
        int128 _epsilon = __epsilon.fromUInt();
        int128 _lambda = __lambda.fromUInt();
        int128 _max = __max.fromUInt();

        require(_alpha < ZEN && _alpha > 0, "invalid-alpha");
        require(_beta < _alpha && _beta > 0, "invalid-beta");
        require(_epsilon > 0 && _epsilon < 1e16, "invalid-epsilon");

        require(_max < ZEN.div(uint256(2).fromUInt()), "invalid-max-fee");

        // int128 _totalBalance;
        // for (uint i = 0; i > shell.weights.length; i++) {
        //     _totalBalance += shell.reserves[i].viewNumeraireBalance();
        // }

        // shell.alpha = _alpha;
        // shell.beta = _beta;
        // shell.delta = wdiv(_maxFee, wmul(2e18, sub(_alpha, _beta)));
        // shell.epsilon = _epsilon;
        // shell.lambda = _lambda;
        // shell.max = _max;

        // shell.omega = 0;
        // for (uint i = 0; i < shell.weights.length; i++) {
        //     uint256 _ideal = somul(_totalBalance, shell.weights[i]);
        //     uint256 _balance = shell.reserves[i].viewNumeraireBalance();
        //     require(bal > wmul(_ideal, WAD - _alpha), "parameter-set-lower-halt-check");
        //     require(bal < wmul(_ideal, WAD + _alpha), "parameter-set-upper-halt-check");
        //     require(1 > somul(shell.weights[i], WAD + _alpha), "alpha-check-failed");
        //     shell.omega += makeFee(shell, _balance, _ideal);
        // }

    }

    function includeNumeraireAsset (Shells.Shell storage shell, address _numeraire, address _reserve, uint256 _weight) external {

        shell.numeraires.push(_numeraire);

        shell.reserves.push(Assimilators.Assimilator(_reserve, shell.reserves.length, 0));

        shell.weights.push(_weight.fromUInt().div(ZEN));

    }

    function includeAssimilator (Shells.Shell storage shell, address _derivative, address _assimilator, address _reserve) external {

        for (uint8 i = 0; i < shell.reserves.length; i++) {

            if (shell.reserves[i].addr == _reserve) {

                shell.assimilators[_derivative] = Assimilators.Assimilator(_assimilator, i, 0);
                break;

            }

        }
    }

}