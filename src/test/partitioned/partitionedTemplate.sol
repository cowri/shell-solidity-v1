
pragma solidity ^0.5.0;

import "abdk-libraries-solidity/ABDKMath64x64.sol";

import "../../interfaces/IAssimilator.sol";

import "../setup/setup.sol";

import "../setup/methods.sol";

contract PartitionedLiquidityTemplate is Setup {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using ShellMethods for Shell;

    Shell s;

    function from_proprotional_state_underflow () public returns (bool success_) {

        s.proportionalDeposit(300e18, 1e50);

        s.setFrozen(true);

        s.partition();

        ( success_, ) = address(s).call(abi.encodeWithSignature(
            "partitionedWithdraw(address[],uint256[])",
            address(dai),
            301e18
        ));

    }

    function from_proportional_state () public returns (uint[] memory) {

        s.proportionalDeposit(300e18, 1e50);

        s.setFrozen(true);

        s.partition();

        return s.partitionedWithdraw(
            address(dai), 100e18
        );

    }

    function from_slightly_unbalanced_state () public returns (uint[] memory) {

        uint startingShells = s.deposit(
            address(dai), 100e18,
            address(usdc), 80e6,
            address(usdt), 90e6,
            address(susd), 30e18
        );

        s.setFrozen(true);

        s.partition();

        return s.partitionedWithdraw(
            address(dai), 10e18,
            address(usdc), 1e18,
            address(usdt), 5e18
        );

    }

}