pragma solidity ^0.5.0;

import "./Assimilators.sol";

import "./Loihi.sol";

import "./UnsafeMath64x64.sol";

library PartitionedLiquidity {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;
    using UnsafeMath64x64 for int128;

    event PartitionRedeemed(address token, address redeemer, uint value);

    int128 constant ONE = 0x10000000000000000;

    event log_int(bytes32, int128);
    event log_ints(bytes32, int128[]);
    event log_uint(bytes32, uint);
    event log_uints(bytes32, uint[]);

    function partitionedWithdraw (
        Loihi.Shell storage shell,
        mapping storage partitions,
        address[] memory _tokens,
        uint[] memory _withdraws
    ) internal returns (
        uint[] memory withdraws_
    ) {

        uint _length = shell.reserves.length;
        uint _totalSupply = shell.totalSupply;

        Loihi.PartitionTicket storage totalSuppliesTicket = partitions[address(this)];
        Loihi.PartitionTicket storage ticket = partitions[msg.sender];

        if (!ticket.active) {

            for (uint i = 0; i < _length; i++) ticket.claims[i] = _totalSupply;
            ticket.active = true;

        }

        _length = _tokens.length;

        for (uint i = 0; i < _length; i++) {

            Loihi.Assimilator memory _assim = shell.assimilators[_tokens[i]];

            require(_assim.addr != address(0), "Shell/unsupported-asset");

            int128 _balance = Assimilators.viewNumeraireBalance(_assim.addr);

            int128 _multiplier = _amounts[i].divu(1e18)
                .div(totalSuppliesTicket.claims[_assim.ix].divu(1e18));

            withdraws_[i] = Assimilators.outputNumeraire(
                _assim.addr,
                msg.sender,
                _balance.mul(_multiplier)
            );

            totalSuppliesTicket.claims[_assim.ix] = burn_sub(
                totalSuppliesTicket.claims[_assim.ix],
                withdraws_[i]
            );

            ticket.claims[_assim.ix] = burn_sub(
                ticket.claims[_assim.ix],
                withdraws_[i]
            );

            emit PartitionRedeemed(_tokens[i], msg.sender, withdraws_[i]);

        }

    }

    function burn_sub(uint x, uint y) private pure returns (uint z) {
        require((z = x - y) <= x, "Shell/burn-underflow");
    }

}