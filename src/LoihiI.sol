pragma solidity ^0.5.0;

interface LoihiI {

    function getOriginPrice (
        address origin,
        address target,
        uint256 originAmount
    ) external view returns (uint256);

    function getTargetPrice (
        address origin,
        address target,
        uint256 originAmount
    ) external view returns (uint256);

    function swapByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        uint256 deadline
    ) external returns (uint256);

    function transferByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 targetMin,
        uint256 deadline,
        address recipient
    ) external returns (uint256);

    function swapByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        uint256 deadline
    ) external returns (uint256);

    function tansferByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        address recipient,
        uint256 deadline
    ) external returns (uint256);

    function selectiveDeposit (
        address[] calldata _flavors,
        uint256[] calldata _amounts
    ) external returns (uint256);

    function selectiveWithdraw (
        address[] calldata _flavors,
        uint256[] calldata _amounts
    ) external returns (uint256);

    function proportionalDeposit (
        uint256 shellTokens,
        uint256 deadline
    ) external returns (uint256[] memory);

    function proportionalWithdraw (
        uint256 shellTokens,
        uint256 deadline
    ) external returns (uint256[] memory);

}