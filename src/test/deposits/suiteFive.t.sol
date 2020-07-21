pragma solidity ^0.5.17;

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

    function test_s5_proportionalDeposit_monotonicity_lower_outOfBand () public {

        (   uint256 _dai,
            uint256 _usdc,
            uint256 _usdt,
            uint256 _susd ) = super.monotonicity_proportional_lower_outOfBand();

        emit log_named_uint("dai", _dai);
        emit log_named_uint("usdc", _usdc);
        emit log_named_uint("usdt", _usdt);
        emit log_named_uint("susd", _susd);

    }

    function test_s5_proportionalDeposit_monotonicity_upper_outOfBand () public {

        (   uint256 _dai,
            uint256 _usdc,
            uint256 _usdt,
            uint256 _susd ) = super.monotonicity_proportional_upper_outOfBand();

        emit log_named_uint("dai", _dai);
        emit log_named_uint("usdc", _usdc);
        emit log_named_uint("usdt", _usdt);
        emit log_named_uint("susd", _susd);

    }
}