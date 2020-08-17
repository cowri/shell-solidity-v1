pragma solidity ^0.5.0;

import "./Assimilators.sol";

import "./Loihi.sol";

import "./UnsafeMath64x64.sol";

library PartitionedLiquidity {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;
    using UnsafeMath64x64 for int128;

    event PoolPartitioned(bool);

    event PartitionRedeemed(address indexed token, address indexed redeemer, uint value);

    int128 constant ONE = 0x10000000000000000;

    function partition (
        Loihi.Shell storage shell,
        mapping (address => Loihi.PartitionTicket) storage partitionTickets
    ) external {

        uint _length = shell.reserves.length;

        Loihi.PartitionTicket storage totalSupplyTicket = partitionTickets[address(this)];

        totalSupplyTicket.initialized = true;

        for (uint i = 0; i < _length; i++) totalSupplyTicket.claims.push(shell.totalSupply);

        emit PoolPartitioned(true);

    }

    function viewPartitionClaims (
        Loihi.Shell storage shell,
        mapping (address => Loihi.PartitionTicket) storage partitionTickets,
        address _addr
    ) external view returns (
        uint[] memory claims_
    ) {

        Loihi.PartitionTicket storage ticket = partitionTickets[_addr];

        if (ticket.initialized) return ticket.claims;

        uint _length = shell.reserves.length;
        uint[] memory claims_ = new uint[](_length);
        uint _balance = shell.balances[msg.sender];

        for (uint i = 0; i < _length; i++) claims_[i] = _balance;

        return claims_;

    }

    function partitionedWithdraw (
        Loihi.Shell storage shell,
        mapping (address => Loihi.PartitionTicket) storage partitionTickets,
        address[] calldata _derivatives,
        uint[] calldata _withdrawals
    ) external returns (
        uint[] memory
    ) {

        uint _length = shell.reserves.length;
        uint _balance = shell.balances[msg.sender];

        Loihi.PartitionTicket storage totalSuppliesTicket = partitionTickets[address(this)];
        Loihi.PartitionTicket storage ticket = partitionTickets[msg.sender];

        if (!ticket.initialized) {

            for (uint i = 0; i < _length; i++) ticket.claims.push(_balance);
            ticket.initialized = true;

        }

        _length = _derivatives.length;

        uint[] memory withdrawals_ = new uint[](_length);

        for (uint i = 0; i < _length; i++) {

            Loihi.Assimilator memory _assim = shell.assimilators[_derivatives[i]];

            require(_assim.addr != address(0), "Shell/unsupported-asset");

            int128 _reserveBalance = Assimilators.viewNumeraireBalance(_assim.addr);

            int128 _multiplier = _withdrawals[i].divu(1e18)
                .div(totalSuppliesTicket.claims[_assim.ix].divu(1e18));

            totalSuppliesTicket.claims[_assim.ix] = burn_sub(
                totalSuppliesTicket.claims[_assim.ix],
                _withdrawals[i]
            );

            ticket.claims[_assim.ix] = burn_sub(
                ticket.claims[_assim.ix],
                _withdrawals[i]
            );

            uint _withdrawal = Assimilators.outputNumeraire(
                _assim.addr,
                msg.sender,
                _reserveBalance.mul(_multiplier)
            );

            withdrawals_[i] = _withdrawal;

            emit PartitionRedeemed(_derivatives[i], msg.sender, withdrawals_[i]);

        }

        return withdrawals_;

    }

    function burn_sub(uint x, uint y) private pure returns (uint z) {
        require((z = x - y) <= x, "Shell/burn-underflow");
    }

}