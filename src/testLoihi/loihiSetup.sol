// pragma solidity ^0.5.6;

// import "../LoihiLocal.sol";
// import "../Loihi.sol";
// import "../LoihiKovan.sol";
// import "../LoihiMainnet.sol";
// import "./adaptersSetup.sol";

// contract PotMock {
//     constructor () public { }
//     function rho () public returns (uint256) { return now - 500; }
//     function drip () public returns (uint256) { return (10 ** 18) * 2; }
//     function chi () public returns (uint256) { return (10 ** 18) * 2; }
// }

// contract LoihiSetup is AdaptersSetup {
//     Loihi l;

//     function setupLoihi () public {
//         setupLocalLoihi();
//     }

//     function setupLocalLoihi () public {
//         setupFlavors();
//         setupAdapters();

//         address pot = address(new PotMock());
//         l = new Loihi(
//             chai, cdai, dai, pot,
//             cusdc, usdc,
//             usdt
//         );


//         ERC20I(chai).approve(address(l), 100000 * (10 ** 18));
//         ERC20I(cdai).approve(address(l), 100000 * (10 ** 18));
//         ERC20I(dai).approve(address(l), 100000 * (10 ** 18));
//         ERC20I(cusdc).approve(address(l), 100000 * (10 ** 18));
//         ERC20I(usdc).approve(address(l), 100000 * (10 ** 18));
//         ERC20I(usdt).approve(address(l), 100000 * (10 ** 18));

//         uint256 weight = WAD / 3;

//         l.includeNumeraireAndReserve(dai, cdaiAdapter);
//         l.includeNumeraireAndReserve(usdc, cusdcAdapter);
//         l.includeNumeraireAndReserve(usdt, usdtAdapter);

//         l.includeAdapter(chai, chaiAdapter, cdaiAdapter, weight);
//         l.includeAdapter(dai, daiAdapter, cdaiAdapter, weight);
//         l.includeAdapter(cdai, cdaiAdapter, cdaiAdapter, weight);
//         l.includeAdapter(cusdc, cusdcAdapter, cusdcAdapter, weight);
//         l.includeAdapter(usdc, usdcAdapter, cusdcAdapter, weight);
//         l.includeAdapter(usdt, usdtAdapter, usdtAdapter, weight);

//         l.setAlpha((5 * WAD) / 10);
//         l.setBeta((25 * WAD) / 100);
//         l.setFeeDerivative(WAD / 10);
//         l.setFeeBase(500000000000000);
        
//         emit log_address("cusdc", cusdc);
//         emit log_address("cdai", cdai);

//     }

//     event log_address(bytes32, address);

//     // function setupLoihiKovan () public {
//     //     l = new LoihiKovan();

//     //     ERC20I(chai).approve(address(l), 100000 * (10 ** 18));
//     //     ERC20I(cdai).approve(address(l), 100000 * (10 ** 18));
//     //     ERC20I(dai).approve(address(l), 100000 * (10 ** 18));
//     //     ERC20I(cusdc).approve(address(l), 100000 * (10 ** 18));
//     //     ERC20I(usdc).approve(address(l), 100000 * (10 ** 18));
//     //     ERC20I(usdt).approve(address(l), 100000 * (10 ** 18));
//     // }

//     // function setupLoihiMainnet () public {
//     //     l = new LoihiMainnet();

//     //     ERC20I(chai).approve(address(l), 100000 * (10 ** 18));
//     //     ERC20I(cdai).approve(address(l), 100000 * (10 ** 18));
//     //     ERC20I(dai).approve(address(l), 100000 * (10 ** 18));
//     //     ERC20I(cusdc).approve(address(l), 100000 * (10 ** 18));
//     //     ERC20I(usdc).approve(address(l), 100000 * (10 ** 18));
//     //     ERC20I(usdt).approve(address(l), 100000 * (10 ** 18));
//     // }


// }