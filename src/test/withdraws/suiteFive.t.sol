pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./withdrawTemplate.sol";

contract SelectiveWithdrawSuiteFive is SelectiveWithdrawTemplate, DSTest {

    function setUp() public {

        l = getLoihiSuiteFive();

    }

    function test_s5_selectiveWithdraw_monotonicity_upper_outOfBand_outOfBounds_to_inBounds_halt_omegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_upper_outOfBand_outOfBounds_to_inBounds_halt_omegaUpdate();

        emit log_named_uint("shellsBurned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_upper_outOfBand_outOfBounds_to_inBounds_halt_noOmegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_upper_outOfBand_outOfBounds_to_inBounds_halt_noOmegaUpdate();

        emit log_named_uint("shellsBurned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_upper_outOfBand_outOfBounds_to_inBounds_noHalt_omegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_upper_outOfBand_outOfBounds_to_inBounds_noHalt_omegaUpdate();

        emit log_named_uint("shellsBurned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_upper_outOfBand_outOfBounds_to_inBounds_noHalt_noOmegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_upper_outOfBand_outOfBounds_to_inBounds_noHalt_noOmegaUpdate();

        emit log_named_uint("shellsBurned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_halt_omegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_halt_omegaUpdate();

        emit log_named_uint("shellsBurned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_halt_noOmegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_halt_noOmegaUpdate();

        emit log_named_uint("shellsBurned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_noHalt_omegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_noHalt_omegaUpdate();

        emit log_named_uint("shellsBurned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_noHalt_noOmegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_noHalt_noOmegaUpdate();

        emit log_named_uint("shellsBurned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_lower_inBounds_to_outOfBounds_halt () public {

        uint256 shellsBurned = super.monotonicity_lower_inBounds_to_outOfBounds_halt();

        emit log_named_uint("shells burned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_lower_inBounds_to_outOfBounds_noHalt () public {

        uint256 shellsBurned = super.monotonicity_lower_inBounds_to_outOfBounds_noHalt();

        emit log_named_uint("shells burned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_halt_omegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_halt_omegaUpdate();

        emit log_named_uint("shells burned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_halt_noOmegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_halt_noOmegaUpdate();

        emit log_named_uint("shells burned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_noHalt_omegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_noHalt_omegaUpdate();

        emit log_named_uint("shells burned", shellsBurned);

    }

    function test_s5_selectiveWithdraw_monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_noHalt_noOmegaUpdate () public {

        uint256 shellsBurned = super.monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_noHalt_noOmegaUpdate();

        emit log_named_uint("shellsBurned", shellsBurned);

    }




}