
pragma solidity ^0.5.17;

import "ds-test/test.sol";

import "./targetSwapTemplate.sol";

contract TargetSwapSuiteFiveTest is TargetSwapTemplate, DSTest {

    function setUp() public {

        l = getLoihiSuiteFive();

    }

    function test_s5_targetSwap_monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_noHalts () public {

        uint256 originAmount = super.monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_noHalts();

        emit log_named_uint("originAmount", originAmount);

    }

    function test_s5_targetSwap_monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_halts () public {

        uint256 originAmount = super.monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_halts();

        emit log_named_uint("originAmount", originAmount);

    }
    
    function test_s5_targetSwap_monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_omegaUpdate () public {

        uint256 originAmount = super.monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_omegaUpdate();

        emit log_named_uint("originAmount", originAmount);

    }

    function test_s5_targetSwap_monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_noOmegaUpdate () public {

        uint256 originAmount = super.monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_noOmegaUpdate();

        emit log_named_uint("originAmount", originAmount);

    }

    function test_s5_targetSwap_monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_updateOmega () public {

        uint256 originAmount = super.monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_updateOmega();

        emit log_named_uint("originAmount", originAmount);

    }

    function test_s5_targetSwap_monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_noUpdateOmega () public {

        uint256 originAmount = super.monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_noUpdateOmega();

        emit log_named_uint("originAmount", originAmount);

    }

    function test_s5_targetSwap_monotonicity_outOfBand_mutuallyOutOfBound_towards_mutuallyInBound_noHalts_omegaUpdate () public {

        uint256 originAmount = super.monotonicity_outOfBand_mutuallyOutOfBound_towards_mutuallyInBound_noHalts_omegaUpdate();

        emit log_named_uint("originAmount", originAmount);

    }

    function test_s5_targetSwap_monotonicity_outOfBand_mutuallyOutOfBound_zero_noHalts_omegaUpdate () public {

        uint256 originAmount = super.monotonicity_outOfBand_mutuallyOutOfBound_zero_noHalts_omegaUpdate();

        emit log_named_uint("originAmount", originAmount);

    }

}