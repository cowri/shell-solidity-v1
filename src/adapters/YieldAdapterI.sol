
pragma solidity ^0.5.0;

interface IYieldWrapper {

    function getNumeraireAmount (
        uint256 amount
    ) external view returns (uint256);

    function getUnderlyingAmount (
        uint256 numeraireAmount
    ) external view returns (uint256);

    function wrap (
        uint256 amount
    ) external returns (uint256);

    function unwrap (
        uint256 amount
    ) external returns (uint256);

    function canRedeem(
        uint256 amount
    ) external returns (uint256);

}