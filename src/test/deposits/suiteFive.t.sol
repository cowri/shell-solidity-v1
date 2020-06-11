pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./depositsTemplate.sol";

contract SelectiveDepositSuiteFive is SelectiveDepositTemplate, DSTest {

    function setUp() public {

        l = getLoihiSuiteFive();

    }

    function test_s5_selectiveDeposit_monotonicity_upper_inBounds_to_outOfBounds_noHalt () public {

        uint256 shellsMinted = super.monotonicity_upper_inBounds_to_outOfBounds_noHalt();

        emit log_named_uint("shellsMinted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_upper_inBounds_to_outOfBounds_halt () public {

        uint256 shellsMinted = super.monotonicity_upper_inBounds_to_outOfBounds_halt();

        emit log_named_uint("shellsMinted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_noHalt_omegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_noHalt_omegaUpdate();

        emit log_named_uint("shellsMinted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_noHalt_noOmegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_noHalt_noOmegaUpdate();

        emit log_named_uint("shells minted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_halt_omegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_halt_omegaUpdate();

        emit log_named_uint("shells minted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_halt_noOmegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_upper_outOfBand_outOfBounds_to_outOfBounds_halt_noOmegaUpdate();

        emit log_named_uint("shells minted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_lower_outOfBand_outOfBounds_to_inBounds_halt_omegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_lower_outOfBand_outOfBounds_to_inBounds_halt_omegaUpdate();

        emit log_named_uint("shells minted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_lower_outOfBand_outOfBounds_to_inBounds_halt_noOmegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_lower_outOfBand_outOfBounds_to_inBounds_halt_noOmegaUpdate();

        emit log_named_uint("shells minted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_lower_outOfBand_outOfBounds_to_inBounds_noHalt_omegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_lower_outOfBand_outOfBounds_to_inBounds_noHalt_omegaUpdate();

        emit log_named_uint("shells minted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_lower_outOfBand_outOfBounds_to_inBounds_noHalt_noOmegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_lower_outOfBand_outOfBounds_to_inBounds_noHalt_noOmegaUpdate();

        emit log_named_uint("shells minted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_halt_omegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_halt_omegaUpdate();

        emit log_named_uint("shells minted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_halt_noOmegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_halt_noOmegaUpdate();

        emit log_named_uint("shells minted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_noHalt_omegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_noHalt_omegaUpdate();

        emit log_named_uint("shells minted", shellsMinted);

    }

    function test_s5_selectiveDeposit_monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_noHalt_noOmegaUpdate () public {

        uint256 shellsMinted = super.monotonicity_lower_outOfBand_outOfBounds_to_outOfBounds_noHalt_noOmegaUpdate();

        emit log_named_uint("shells minted", shellsMinted);

    }
}