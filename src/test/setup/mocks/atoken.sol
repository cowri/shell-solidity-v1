pragma solidity ^0.5.0;

import "./erc20.sol";

contract ATokenMock is ERC20Mock {

    ERC20Mock underlying;

    constructor(
        address _underlying,
        string memory _name,
        string memory _symbols,
        uint8 _decimals,
        uint256 _amount
    ) ERC20Mock (_name, _symbols, _decimals, _amount) public {

        underlying = ERC20Mock(_underlying);
        
    }

    function deposit (uint256 amount) public returns (uint) {
        _mint(msg.sender, amount);
        safeTransferFrom(underlying, msg.sender, address(this), amount);
        return amount;
    }

    function redeem (uint256 amount) public returns (uint) {
        _burn(msg.sender, amount);
        safeTransfer(underlying, msg.sender, amount);
        return amount;
    }

    function safeTransfer(ERC20Mock token, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(0xa9059cbb, to, value));
    }

    function safeTransferFrom(ERC20Mock token, address from, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(ERC20Mock token, address spender, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function callOptionalReturn(address token, bytes memory data) private {
        (bool success, bytes memory returnData) = token.call(data);
        assembly {
            if eq(success, 0) {
                revert(add(returnData, 0x20), returndatasize)
            }
        }
    }

}