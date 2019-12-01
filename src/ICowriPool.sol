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

    function omnibus (
        address[] calldata _shells,
        address[] calldata tokenns,
        uint256[] calldata pairs,
        uint256[] calldata amounts,
        uint256[] calldata limits,
        bool[] calldata types,
        uint256 deadlinne
    ) external returns (uint256[] memory);

    function microSwapByOrigin (
        address shell,
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        uint256 deadline
    ) external returns (uint256);

    function microTransferByOrigin (
        address shell,
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        address recipient,
        uint256 deadline
    ) external returns (uint256);

    function macroSwapByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        uint256 deadline
    ) external returns (uint256);

    function macroTransferByOrigin (
        address origin,
        address target,
        uint256 originAmount,
        uint256 minTargetAmount,
        address recipient,
        uint256 deadline
    ) external returns (uint256);

    function microSwapByTarget (
        address shell,
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        uint256 deadline
    ) external returns (uint256);

    function microTransferByTarget (
        address shell,
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        address recipient,
        uint256 deadline
    ) external returns (uint256);

    function macroSwapByTarget (
        address origin,
        address target,
        uint256 targetAmount,
        uint256 maxOriginAmount,
        uint256 deadline
    ) external returns (uint256);

    function macroTransferByTarget (
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