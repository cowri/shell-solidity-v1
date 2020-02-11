pragma solidity ^0.5.12;

import "./LoihiRoot.sol";

contract LoihiCallAdapters is LoihiRoot {

    function supportsInterface (bytes4 interfaceID) external view returns (bool) {
        return interfaceID == ERC20ID
            || interfaceID == ERC165ID;
    }

    function setAlpha (uint256 _alpha) public onlyOwner {
        alpha = _alpha;
    }

    function setBeta (uint256 _beta) public onlyOwner {
        beta = _beta;
    }

    function setFeeDerivative (uint256 _feeDerivative) public onlyOwner {
        feeDerivative = _feeDerivative;
    }

    function setFeeBase (uint256 _feeBase) public onlyOwner {
        feeBase = _feeBase;
    }

    function includeNumeraireAndReserve (address numeraire, address reserve) public onlyOwner {
        numeraires.push(numeraire);
        reserves.push(reserve);
    }

    function includeAdapter (address flavor, address adapter, address reserve, uint256 weight) public {
        flavors[flavor] = Flavor(adapter, reserve, weight);
    }

    function excludeAdapter (address flavor) public {
        delete flavors[flavor];
    }

    function dViewRawAmount (address addr, uint256 amount) internal view returns (uint256) {
        (bool success, bytes memory result) = addr.staticcall(abi.encodeWithSelector(0x049ca270, amount)); // encoded selector of "getNumeraireAmount(uint256");
        assert(success);
        return abi.decode(result, (uint256));
    }

    function dViewNumeraireAmount (address addr, uint256 amount) internal view returns (uint256) {
        (bool success, bytes memory result) = addr.staticcall(abi.encodeWithSelector(0xf5e6c0ca, amount)); // encoded selector of "getNumeraireAmount(uint256");
        assert(success);
        return abi.decode(result, (uint256));
    }

    function dViewNumeraireBalance (address addr) internal view returns (uint256) {
        (bool success, bytes memory result) = addr.staticcall(abi.encodeWithSelector(0xac969a73, addr)); // encoded selector of "getNumeraireAmount(uint256");
        assert(success);
        return abi.decode(result, (uint256));
    }

    function dGetNumeraireAmount (address addr, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xb2e87f0f, amount)); // encoded selector of "getNumeraireAmount(uint256");
        assert(success);
        return abi.decode(result, (uint256));
    }

    function dGetNumeraireBalance (address addr) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0x10df6430)); // encoded selector of "getNumeraireBalance()";
        assert(success);
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @dev this function delegate calls addr, which is an interface to the required functions for retrieving and transfering numeraire and raw values and vice versa
    /// @param addr the address to the interface wrapper to be delegatecall'd
    /// @param amount the numeraire amount to be transfered into the contract. will be adjusted to the raw amount before transfer
    function dIntakeRaw (address addr, uint256 amount) internal {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xfa00102a, amount)); // encoded selector of "intakeRaw(uint256)";
        assert(success);
    }

    /// @author james foley http://github.com/realisation
    /// @dev this function delegate calls addr, which is an interface to the required functions for retrieving and transfering numeraire and raw values and vice versa
    /// @param addr the address to the interface wrapper to be delegatecall'd
    /// @param amount the numeraire amount to be transfered into the contract. will be adjusted to the raw amount before transfer
    function dIntakeNumeraire (address addr, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0x7695ab51, amount)); // encoded selector of "intakeNumeraire(uint256)";
        assert(success);
        return abi.decode(result, (uint256));
    }

    /// @author james foley http://github.com/realisation
    /// @dev this function delegate calls addr, which is an interface to the required functions for retrieving and transfering numeraire and raw values and vice versa
    /// @param addr the address of the interface wrapper to be delegatecall'd
    /// @param dst the destination to which to send the raw amount
    /// @param amount the raw amount of the asset to send
    function dOutputRaw (address addr, address dst, uint256 amount) internal {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xf09a3fc3, dst, amount)); // encoded selector of "outputRaw(address,uint256)";
        assert(success);
    }

    /// @author james foley http://github.com/realisation
    /// @dev this function delegate calls addr, which is an interface to the required functions to retrieve the numeraire and raw values and vice versa
    /// @param addr address of the interface wrapper
    /// @param dst the destination to send the raw amount to
    /// @param amount the numeraire amount of the asset to be sent. this will be adjusted to the corresponding raw amount
    /// @return the raw amount of the asset that was transfered
    function dOutputNumeraire (address addr, address dst, uint256 amount) internal returns (uint256) {
        (bool success, bytes memory result) = addr.delegatecall(abi.encodeWithSelector(0xef40df22, dst, amount)); // encoded selector of "outputNumeraire(address,uint256)";
        assert(success);
        return abi.decode(result, (uint256));
    }
}