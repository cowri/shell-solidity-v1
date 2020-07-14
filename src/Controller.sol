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

import "./ShellMath.sol";

import "./Loihi.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

library Controller {

    int128 constant ONE = 0x10000000000000000;

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    using Assimilators for address;

    event ParametersSet(uint256 alpha, uint256 beta, uint256 delta, uint256 epsilon, uint256 lambda);

    function setParams (
        Loihi.Shell storage shell,
        Loihi.Assimilator[] storage reserves,
        uint256 _alpha,
        uint256 _beta,
        uint256 _max,
        uint256 _epsilon,
        uint256 _lambda
    ) internal returns (uint256 max_) {

        require(_max <= .5e18, "Shell/parameter-invalid-max");

        int128 _gLiq;
        int128[] memory _bals = new int128[](reserves.length);
        for (uint i = 0; i < _bals.length; i++) {
            int128 _bal = reserves[i].addr.viewNumeraireBalance();
            _gLiq += _bal;
            _bals[i] = _bal;
        }

        shell.alpha = _alpha.divu(1e18);
        shell.beta = _beta.divu(1e18);
        shell.delta = _max.divu(1e18).div(uint(2).fromUInt().mul(shell.alpha.sub(shell.beta)));
        shell.epsilon = _epsilon.divu(1e18);
        if (shell.epsilon.mulu(1e18) < _epsilon) shell.epsilon = shell.epsilon.add(uint(1).divu(1e18));
        shell.lambda = _lambda.divu(1e18);

        require(shell.alpha < ONE && shell.alpha > 0, "Shell/parameter-invalid-alpha");
        require(shell.beta <= shell.alpha && shell.beta >= 0, "Shell/parameter-invalid-beta");
        require(shell.epsilon >= 0 && _epsilon < 1e16, "Shell/parameter-invalid-epsilon");
        require(shell.lambda >= 0 && shell.lambda <= ONE, "Shell/parameter-invalid-lambda");

        int128 _psi = ShellMath.calculateFee(_gLiq, _bals, shell.beta, shell.delta, shell.weights);

        require(shell.omega >= _psi, "Shell/paramter-invalid-psi");

        shell.omega = _psi;

        emit ParametersSet(_alpha, _beta, shell.delta.mulu(1e18), _epsilon, _lambda);

        max_ = _max;

    }

    function includeAsset (
        Loihi.Shell storage shell,
        mapping (address => Loihi.Assimilator) storage assimilators,
        Loihi.Assimilator[] storage numeraires,
        Loihi.Assimilator[] storage reserves,
        address _numeraire,
        address _numeraireAssim,
        address _reserve,
        address _reserveAssim,
        uint256 _weight
    ) internal {

        Loihi.Assimilator storage _numeraireAssimilator = assimilators[_numeraire];

        _numeraireAssimilator.addr = _numeraireAssim;

        _numeraireAssimilator.ix = uint8(numeraires.length);

        numeraires.push(_numeraireAssimilator);

        Loihi.Assimilator storage _reserveAssimilator = assimilators[_reserve];

        _reserveAssimilator.addr = _reserveAssim;

        _reserveAssimilator.ix = uint8(reserves.length);

        reserves.push(_reserveAssimilator);

        shell.weights.push(_weight.divu(1e18).add(uint256(1).divu(1e18)));

    }

    function includeAssimilator (
        mapping (address => Loihi.Assimilator) storage assimilators,
        address _numeraire,
        address _derivative,
        address _assimilator
    ) internal {

        Loihi.Assimilator storage _numeraireAssim = assimilators[_numeraire];

        assimilators[_derivative] = Loihi.Assimilator(_assimilator, _numeraireAssim.ix);

    }

}