pragma solidity ^0.5.0;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20Detailed.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "ds-math/math.sol";

contract ATokenMock is ERC20, ERC20Detailed, ERC20Mintable, DSMath {
    ERC20 underlying;
    constructor(address _underlying, string memory _name, string memory _symbols, uint8 _decimals, uint256 _amount)
    ERC20Detailed(_name, _symbols, _decimals) public {
        _mint(msg.sender, _amount);
        underlying = ERC20(_underlying);
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

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(0xa9059cbb, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(address(token), abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
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