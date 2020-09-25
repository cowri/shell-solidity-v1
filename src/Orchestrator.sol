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

pragma solidity ^0.5.0;

import "./Assimilators.sol";

import "./ShellMath.sol";

import "./ShellStorage.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

library Orchestrator {

    using ABDKMath64x64 for int128;
    using ABDKMath64x64 for uint256;

    int128 constant ONE_WEI = 0x12;

    event ParametersSet(uint256 alpha, uint256 beta, uint256 delta, uint256 epsilon, uint256 lambda);

    event AssetIncluded(address indexed numeraire, address indexed reserve, uint weight);

    event AssimilatorIncluded(address indexed derivative, address indexed numeraire, address indexed reserve, address assimilator);

    function setParams (
        ShellStorage.Shell storage shell,
        uint256 _alpha,
        uint256 _beta,
        uint256 _feeAtHalt,
        uint256 _epsilon,
        uint256 _lambda
    ) external {

        require(0 < _alpha && _alpha < 1e18, "Shell/parameter-invalid-alpha");

        require(0 <= _beta && _beta < _alpha, "Shell/parameter-invalid-beta");

        require(_feeAtHalt <= .5e18, "Shell/parameter-invalid-max");

        require(0 <= _epsilon && _epsilon <= .01e18, "Shell/parameter-invalid-epsilon");

        require(0 <= _lambda && _lambda <= 1e18, "Shell/parameter-invalid-lambda");

        int128 _omega = getFee(shell);

        shell.alpha = (_alpha + 1).divu(1e18);

        shell.beta = (_beta + 1).divu(1e18);

        shell.delta = ( _feeAtHalt ).divu(1e18).div(uint(2).fromUInt().mul(shell.alpha.sub(shell.beta))) + ONE_WEI;

        shell.epsilon = (_epsilon + 1).divu(1e18);

        shell.lambda = (_lambda + 1).divu(1e18);
        
        int128 _psi = getFee(shell);
        
        require(_omega >= _psi, "Shell/parameters-increase-fee");

        emit ParametersSet(_alpha, _beta, shell.delta.mulu(1e18), _epsilon, _lambda);

    }

    function getFee (
        ShellStorage.Shell storage shell
    ) private view returns (
        int128 fee_
    ) {

        int128 _gLiq;

        int128[] memory _bals = new int128[](shell.assets.length);

        for (uint i = 0; i < _bals.length; i++) {

            int128 _bal = Assimilators.viewNumeraireBalance(shell.assets[i].addr);

            _bals[i] = _bal;

            _gLiq += _bal;

        }

        fee_ = ShellMath.calculateFee(_gLiq, _bals, shell.beta, shell.delta, shell.weights);

    }
    
 
    function initialize (
        ShellStorage.Shell storage shell,
        address[] storage numeraires,
        address[] storage reserves,
        address[] storage derivatives,
        address[] calldata _assets,
        uint[] calldata _assetWeights,
        address[] calldata _derivativeAssimilators
    ) external {
        
        for (uint i = 0; i < _assetWeights.length; i++) {

            uint ix = i*5;
        
            numeraires.push(_assets[ix]);
            derivatives.push(_assets[ix]);

            reserves.push(_assets[2+ix]);
            if (_assets[ix] != _assets[2+ix]) derivatives.push(_assets[2+ix]);
            
            includeAsset(
                shell,
                _assets[ix],   // numeraire
                _assets[1+ix], // numeraire assimilator
                _assets[2+ix], // reserve
                _assets[3+ix], // reserve assimilator
                _assets[4+ix], // reserve approve to
                _assetWeights[i]
            );
            
        }
        
        for (uint i = 0; i < _derivativeAssimilators.length / 5; i++) {
            
            uint ix = i * 5;

            derivatives.push(_derivativeAssimilators[ix]);

            includeAssimilator(
                shell,
                _derivativeAssimilators[ix],   // derivative
                _derivativeAssimilators[1+ix], // numeraire
                _derivativeAssimilators[2+ix], // reserve
                _derivativeAssimilators[3+ix], // assimilator
                _derivativeAssimilators[4+ix]  // derivative approve to
            );

        }

    }

    function includeAsset (
        ShellStorage.Shell storage shell,
        address _numeraire,
        address _numeraireAssim,
        address _reserve,
        address _reserveAssim,
        address _reserveApproveTo,
        uint256 _weight
    ) private {

        require(_numeraire != address(0), "Shell/numeraire-cannot-be-zeroth-adress");

        require(_numeraireAssim != address(0), "Shell/numeraire-assimilator-cannot-be-zeroth-adress");

        require(_reserve != address(0), "Shell/reserve-cannot-be-zeroth-adress");

        require(_reserveAssim != address(0), "Shell/reserve-assimilator-cannot-be-zeroth-adress");

        require(_weight < 1e18, "Shell/weight-must-be-less-than-one");

        if (_numeraire != _reserve) safeApprove(_numeraire, _reserveApproveTo, uint(-1));

        ShellStorage.Assimilator storage _numeraireAssimilator = shell.assimilators[_numeraire];

        _numeraireAssimilator.addr = _numeraireAssim;

        _numeraireAssimilator.ix = uint8(shell.assets.length);

        ShellStorage.Assimilator storage _reserveAssimilator = shell.assimilators[_reserve];

        _reserveAssimilator.addr = _reserveAssim;

        _reserveAssimilator.ix = uint8(shell.assets.length);

        int128 __weight = _weight.divu(1e18).add(uint256(1).divu(1e18));

        shell.weights.push(__weight);

        shell.assets.push(_numeraireAssimilator);

        emit AssetIncluded(_numeraire, _reserve, _weight);

        emit AssimilatorIncluded(_numeraire, _numeraire, _reserve, _numeraireAssim);

        if (_numeraireAssim != _reserveAssim) {

            emit AssimilatorIncluded(_reserve, _numeraire, _reserve, _reserveAssim);

        }

    }
    
    function includeAssimilator (
        ShellStorage.Shell storage shell,
        address _derivative,
        address _numeraire,
        address _reserve,
        address _assimilator,
        address _derivativeApproveTo
    ) private {

        require(_derivative != address(0), "Shell/derivative-cannot-be-zeroth-address");

        require(_numeraire != address(0), "Shell/numeraire-cannot-be-zeroth-address");

        require(_reserve != address(0), "Shell/numeraire-cannot-be-zeroth-address");

        require(_assimilator != address(0), "Shell/assimilator-cannot-be-zeroth-address");
        
        safeApprove(_numeraire, _derivativeApproveTo, uint(-1));

        ShellStorage.Assimilator storage _numeraireAssim = shell.assimilators[_numeraire];

        shell.assimilators[_derivative] = ShellStorage.Assimilator(_assimilator, _numeraireAssim.ix);

        emit AssimilatorIncluded(_derivative, _numeraire, _reserve, _assimilator);

    }

    function safeApprove (
        address _token,
        address _spender,
        uint256 _value
    ) private {

        ( bool success, bytes memory returndata ) = _token.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));

        require(success, "SafeERC20: low-level call failed");

    }

    function viewShell (
        ShellStorage.Shell storage shell
    ) external view returns (
        uint alpha_,
        uint beta_,
        uint delta_,
        uint epsilon_,
        uint lambda_
    ) {

        alpha_ = shell.alpha.mulu(1e18);

        beta_ = shell.beta.mulu(1e18);

        delta_ = shell.delta.mulu(1e18);

        epsilon_ = shell.epsilon.mulu(1e18);

        lambda_ = shell.lambda.mulu(1e18);

    }

}