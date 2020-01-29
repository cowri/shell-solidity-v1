pragma solidity ^0.5.12;

import "ds-math/math.sol";

import "./ChaiI.sol";
import "./CTokenI.sol";
import "./ERC20I.sol";
import "./ERC20Token.sol";

contract PotLike {
    function chi() external returns (uint256);
}

contract Loihi is DSMath {

    mapping(address => uint256) public reserves;

    struct flavor { address adaptation; address reserver; }
    mapping(address => flavor) public adaptations;

    constructor ( ) public { }

    function includeAdaptation (address stablecoin, address adaptation) public onlyOwner {

    }

    function excludeAdaptation (address stablecoin) public onlyOwner {

    }

    function swapByTarget (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline) public returns (uint256) {
        return executeTargetTrade(origin, maxOriginAmount, target, targetAmount, deadline, msg.sender);
    }
    function transferByTarget (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeTargetTrade(origin, maxOriginAmount, target, targetAmount, deadline, recipient);
    }

    function swapByOrigin (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline) public returns (uint256) {
        return executeOriginTrade(origin, originAmount, target, minTargetAmount, deadline, msg.sender);
    }
    function transferByOrigin (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {
        return executeTargetTrade(origin, originAmount, target, minTargetAmount, deadline, recipient);
    }

    function executeOriginTrade (address origin, uint256 originAmount, address target, uint256 minTargetAmount, uint256 deadline, address recipient) public returns (uint256) {
        Flavor memory originRolodex = adaptations[origin];
        Flavor memory targetRolodex = adaptations[target];
        uint256 originNumeraireAmount = originRolodex.adaptation.delegateCall(abi.encodeWithSignature("getNumeraireAmount(uint256)", originAmount));
        uint256 originNumeraireBalance = originRolodex.reserve.delegateCall(abi.encodeWithSignature("getNumeraireBalance()"));
        uint256 targetNumeraireBalance = targetRolodex.reserve.delegateCall(abi.encodeWithSignature("getNumeraireBalance()"));
        uint256 targetNumeraireAmount = wdiv(
            wmul(originNumeraireAmount, targetNumeraireBalance),
            add(originNumeraireAmount, originNumeraireBalance)
        );

        if (origin == originRolodex.reserve) {
            originRolodex.reserve.delegateCall(abi.encode("transferFrom", msg.sender, originAmount));
        } else {
            uint256 originNumeraireAddition = originRolodex.adaptation.delegateCall(abi.encodeWithSignature("unwrap(intake(uint256)", originAmount));
            originRolodex.reserve.delegateCall(abi.encodeWithSignature("wrap(uint256)"), originNumeraireAddition);
        }

        if (target == targetRolodex.reserve) {
            uint256 targetRolodex.delegateCall(abi.encode("transferNumeraireAmount", recipient, targetNumeraireAmount));
        } else {
            uint256 targetNumeraireSubtraction = targetRolodex.reserve.delegateCall(abi.encode("unwrap(uint256"), targetNumeraireAmount));
            return targetRolodex.adaptation.delegateCall(abi.encode("transferNumeraireAmount(address,uint256)", recipient, targetNumeraireSubtraction));
        }

    }

    function executeTargetTrade (address origin, uint256 maxOriginAmount, address target, uint256 targetAmount, uint256 deadline, address recipient) public returns (uint256) {
        require(deadline > now, "transaction deadline has passed");
    }

    function intake (address received, uint256 amount) public {
        if (received == address(chai)) chai.transferFrom(msg.sender, address(this), amount);
        else if (received == address(cusdc)) cusdc.transferFrom(msg.sender, address(this), amount);
        else if (received == address(usdt)) usdt.transferFrom(msg.sender, address(this), amount);
        else if (received == address(cdai)) {
            cdai.transferFrom(msg.sender, address(this), amount);
        } else if (received == address(dai)) {
            dai.transferFrom(msg.sender, address(this), amount);
        } else if (received == address(usdc)) {
            usdc.transferFrom(msg.sender, address(this), amount);
        }
    }

    function output (address sending, uint256 amount, address recipient) public returns (uint256) {
        if (sending == address(chai)) chai.transfer(recipient, amount);
        else if (sending == address(cusdc)) cusdc.transfer(recipient, amount);
        else if (sending == address(usdt)) usdt.transfer(recipient, amount);
        else if (sending == address(cdai)) {
            cdai.transfer(recipient, amount);
        } else if (sending == address(dai)) {
            dai.transfer(recipient, amount);
        } else if (sending == address(usdc)) {
            usdc.transfer(recipient, amount);
        }
    }

    function getNumeraireAmount (address flavor, uint256 amount) public returns (uint256) {
        if (flavor == address(chai)) {
            return wmul(amount, pot.chi());
        } else if (flavor == address(cusdc)) {
            return wmul(amount, cusdc.exchangeRateCurrent());
        } else if (flavor == address(cdai)) {
            return wmul(amount, cdai.exchangeRateCurrent());
        } else if (flavor == address(dai) || flavor == address(usdc) || flavor == address(usdt)) {
            return amount;
        }
    }

    function getFlavorAmount (address flavor, uint256 amount) public returns (uint256) {
    }

    function depositLiquidity (address[] calldata flavors, uint256[] calldata amounts) external returns (uint256) {


    }

    function withdrawLiquidity (address[] calldata flavors, uint256[] calldata amounts) external returns (uint256) {

    }


}
