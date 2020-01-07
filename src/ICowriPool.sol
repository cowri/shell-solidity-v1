pragma solidity ^0.5.0;


interface ICowriPool {

    function getOriginPrice (
        address origin,
        address target,
        uint256 originAmount
    ) external view returns (uint256);

    function getMicroOriginPrice (
        address shell,
        address origin,
        address target,
        uint256 originAmount
    ) external view returns (uint256);

    function getMicroTargetPrice (
        address shell,
        address origin,
        address target,
        uint256 targetAmount
    ) external view returns (uint256);

    function swapByOrigin (
        address shell,
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        uint256 deadline
    ) external returns (uint256);

    function swapByOrigin (
        address[] calldata shells,
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        uint256 deadline
    ) external returns (uint256);

    function swapByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        uint256 deadline
    ) external returns (uint256);

    function transferByOrigin (
        address shell,
        address origin,
        address target,
        uint256 originAmount,
        uint256 targetMin,
        uint256 deadline,
        address recipient
    ) external returns (uint256);

    function transferByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
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

    function swapByTarget (
        address shell,
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        uint256 deadline
    ) external returns (uint256);

    function swapByTarget (
        address[] calldata shells,
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        uint256 deadline
    ) external returns (uint256);

    function tansferByTarget (
        address shell,
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        address recipient,
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

    function depositSelectiveLiquidity (
        address _shell,
        uint256[] calldata _amounts
    ) external returns (uint256);

    function withdrawSelectiveLiquidity (
        address _shell,
        uint256[] calldata _amounts
    ) external returns (uint256);

    function depositLiquidity (
        address _shell,
        uint256 amount,
        uint256 deadline
    ) external returns (uint256);

    function withdrawLiquidity (
        address _shell,
        uint256 liquidityToBurn,
        uint256[] calldata limits,
        uint256 deadline
    ) external returns (uint256[] memory);

    function getTotalCapital (
        address shell
    ) external view returns (uint256);

    function createShell (
        address[] calldata tokens
    ) external returns (address);

    function registerShell (
        address shell
    ) external returns (address);

    function activateShell (
        address _shell
    ) external returns (bool);

    function deactivateShell (
        address _shell
    ) external returns (bool);

    function findShellByTokens (
        address[] calldata _addresses
    ) external view returns (address);

    function getAllShellsForPair (
        address one,
        address two
    ) external view returns (address[] memory);

    function getActiveShellsForPair (
        address one,
        address two
    ) external view returns (address[] memory);

    function getShellBalance(
        address _shell
    ) external view returns (uint256);

    function getShellBalanceOf(
        address _shell,
        address _token
    ) external view returns (uint256);

    function getTotalShellCapital (
        address shell
    ) external view returns (uint256);


}