pragma solidity ^0.5.12;

interface IAdapter {
    function intakeNumeraire (uint256 amount) external returns (uint256);
    function intakeRaw (uint256 amount) external;
    function outputNumeraire (address dst, uint256 amount) external returns (uint256);
    function outputRaw (address dst, uint256 amount) external;
    function getNumeraireAmount (uint256) external returns (uint256);
    function getRawAmount (uint256) external returns (uint256);
    function getNumeraireBalance (uint256) external returns (uint256);
    function viewRawAmount (uint256) external view returns (uint256);
    function viewNumeraireAmount (uint256) external view returns (uint256);
    function viewNumeraireBalance (address addr) external view returns (uint256);
}