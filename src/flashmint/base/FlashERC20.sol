pragma solidity 0.5.16;


import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/SafeERC20.sol";
import "./IBorrower.sol";

// @title FlashERC20
// @notice A simple ERC20 wrapper with flash-mint functionality.
contract FlashERC20 is ERC20 {

    using SafeERC20 for ERC20;

    // ERC20-Detailed
    string public name = "Flash ERC20"; // e.g. Flash DAI
    string public symbol = "fERC20"; // e.g.: fDAI
    uint8  public decimals = 18;

    // Set underlying to addres of the underlying asset.
    ERC20 public underlying = ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F); // DAI address as an example

    // Events with parameter names that are consistent with the WETH9 contract.
    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);
    event FlashMint(address indexed src, uint256 wad);

    // Mints fERC20 in 1-to-1 correspondence with underlying.
    function deposit(uint256 wad) public {
        underlying.safeTransferFrom(msg.sender, address(this), wad);
        _mint(msg.sender, wad);
        emit Deposit(msg.sender, wad);
    }

    // Redeems fERC20 1-to-1 for underlying.
    function withdraw(uint256 wad) public {
        _burn(msg.sender, wad); // reverts if `msg.sender` does not have enough fERC20
        underlying.safeTransfer(msg.sender, wad);
        emit Withdrawal(msg.sender, wad);
    }

    // Allows anyone to mint unbacked fWETH as long as it gets burned by the end of the transaction.
    function flashMint(uint256 amount) public {
        // mint tokens
        _mint(msg.sender, amount);

        // hand control to borrower
        IBorrower(msg.sender).executeOnFlashMint(amount);

        // burn tokens
        _burn(msg.sender, amount); // reverts if `msg.sender` does not have enough units of the FMT

        // double-check that all fERC20 is backed by the underlying
        assert(underlying.balanceOf(address(this)) >= totalSupply());

        emit FlashMint(msg.sender, amount);
    }
}