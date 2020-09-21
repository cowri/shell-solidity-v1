
pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./originSwapTemplate.sol";

contract OriginSwapSuiteFiveTest is OriginSwapTemplate, DSTest {

    function setUp() public {

        s = getShellSuiteFive();

    }

    function test_s5_originSwap_monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_noHalts () public {

        uint256 targetAmount = super.monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_noHalts();

        emit log_named_uint("targetAmount", targetAmount);

    }

    function test_s5_originSwap_monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_halts () public {

        uint256 targetAmount = super.monotonicity_mutuallyInBounds_to_mutuallyOutOfBounds_halts();

        emit log_named_uint("targetAmount", targetAmount);

    }
    
    function test_s5_originSwap_monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_omegaUpdate () public {

        uint256 targetAmount = super.monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_omegaUpdate();

        emit log_named_uint("targetAmount", targetAmount);

    }

    function test_s5_originSwap_monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_noOmegaUpdate () public {

        uint256 targetAmount = super.monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyOutOfBounds_noHalts_noOmegaUpdate();

        emit log_named_uint("targetAmount", targetAmount);

    }

    function test_s5_originSwap_monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_updateOmega () public {

        uint256 targetAmount = super.monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_updateOmega();

        emit log_named_uint("targetAmount", targetAmount);

    }

    function test_s5_originSwap_monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_noUpdateOmega () public {

        uint256 targetAmount = super.monotonicity_outOfBand_mutuallyOutOfBounds_to_mutuallyInBounds_noHalts_noUpdateOmega();

        emit log_named_uint("targetAmount", targetAmount);

    }

    function test_s5_originSwap_monotonicity_outOfBand_mutuallyOutOfBound_towards_mutuallyInBound_noHalts_omegaUpdate () public {

        uint256 targetAmount = super.monotonicity_outOfBand_mutuallyOutOfBound_towards_mutuallyInBound_noHalts_omegaUpdate();

        emit log_named_uint("targetAmount", targetAmount);

    }


}