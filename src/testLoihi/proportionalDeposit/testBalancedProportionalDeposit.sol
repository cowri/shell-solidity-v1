pragma solidity ^0.5.6;


import "ds-test/test.sol";
import "ds-math/math.sol";
import "../loihiSetup.sol";
import "../flavorsSetup.sol";
import "../../IAdapter.sol";

contract Agent is DSTest, FlavorsSetup {
    Loihi l;
    constructor (address _l) public {
        l = Loihi(_l);
        emit log_named_address("this", address(this));
    }

    function approve () public {
        setupFlavors();
        approveFlavors(address(l));
    }

    function deposit () public {
        l.proportionalDeposit(30*(10**18));
    }

}

contract LoihiTest is LoihiSetup, DSMath, DSTest {

    function setUp() public {

        Agent falseAddress = new Agent(address(msg.sender));

        setupFlavors();
        setupAdapters();
        setupLoihi();
        approveFlavors(address(l));
        includeAdapters(address(l), 1);

        l.proportionalDeposit(30*WAD);
        l.proportionalWithdraw(30*WAD);

    }

    function testThing () public {
        emit log_named_address("test address", address(this));
        Agent agentOne = new Agent(address(l));
        agentOne.approve();
        agentOne.deposit();
        l.proportionalDeposit(30*WAD);
        uint256 balance = l.balanceOf(address(this));
        uint256 totalSupply = l.totalSupply();
        l.proportionalWithdraw(balance);
        uint256 balanceAfter = l.balanceOf(address(this));
        emit log_named_uint("totalSupply", totalSupply);
        emit log_named_uint("balance", balance);
        emit log_named_uint("balanceAfter", balanceAfter);
    }

    // function testproportionalDeposit () public {

    //     uint256 mintedShells = l.proportionalDeposit(100 * (10 ** 18));
    //     assertEq(mintedShells, 100 * (10 ** 18));

    //     // uint256 cusdcBal = IERC20(cusdc).balanceOf(address(l)); // 165557372275ish
    //     // uint256 cdaiBal = IERC20(cdai).balanceOf(address(l)); // 163925889326ish
    //     // uint256 usdtBal = IERC20(usdt).balanceOf(address(l)); // 33333333333333333300

    //     uint256 cdaiBal = IERC20(cdai).balanceOf(address(l));
    //     uint256 cusdcBal = IERC20(cusdc).balanceOf(address(l));
    //     uint256 usdtBal = IERC20(usdt).balanceOf(address(l));
    //     // uint256 asusdBal = IERC20(asusd).balanceOf(address(l));

    //     uint256 usdtNumeraireAmount = IAdapter(usdtAdapter).getNumeraireAmount(usdtBal);
    //     uint256 cusdcNumeraireAmount = IAdapter(cusdcAdapter).getNumeraireAmount(cusdcBal);
    //     uint256 cdaiNumeraireAmount = IAdapter(cdaiAdapter).getNumeraireAmount(cdaiBal);
        
    //     emit log_named_uint("cusdcbal", cusdcBal);
    //     emit log_named_uint("cdaibal", cdaiBal);
    //     emit log_named_uint("usdtBal", usdtBal);

    //     emit log_named_uint("cusdcNumeraireAmount", cusdcNumeraireAmount);
    //     emit log_named_uint("cdaiNumeraireAmount", cdaiNumeraireAmount);
    //     emit log_named_uint("usdtNumeraireAmount", usdtNumeraireAmount);

    //     // assertEq(usdtNumeraireAmount / (10 ** 10), 3333333300);
    //     // assertEq(cusdcNumeraireAmount / (10 ** 10), 3333333300);
    //     // assertEq(cdaiNumeraireAmount / (10 ** 10), 3333333333);

    // }

    // event log_uints(bytes32, uint256[]);
    // event log_bytes4(bytes32, bytes4);

    // function testProportionalDepositIntoSubOnePool () public {
    //     emit log_bytes4("totalreserve", l.totalReserves.selector);

    //     uint256 mintedShells = l.proportionalDeposit(100 * (10 ** 18));
    //     assertEq(mintedShells, 100 * (10 ** 18));
    //     // (uint256 totalBalance, uint256[] memory balances) = l.totalReserves();
    //     // emit log_named_uint("totalBal", totalBalance);
    //     // emit log_uints("balances", balances);

    //     uint256[] memory burnedShells = l.proportionalWithdraw(mintedShells-1);

    //     // (totalBalance, balances) = l.totalReserves();
    //     // emit log_named_uint("totalBal", totalBalance);
    //     // emit log_uints("balances", balances);
    //     // emit log_uints("burnedShells", burnedShells);

    //     mintedShells = l.proportionalDeposit(10*WAD);
    //     emit log_named_uint("mintedShells", mintedShells);
    //     // (totalBalance, balances) = l.totalReserves();
    //     // emit log_named_uint("totalBal", totalBalance);
    //     // emit log_uints("balances", balances);
    //     // emit log_uints("burnedShells", burnedShells);

    //     burnedShells  = l.proportionalWithdraw(mintedShells/2);

    //     // (totalBalance, balances) = l.totalReserves();
    //     // emit log_named_uint("totalBal", totalBalance);
    //     // emit log_uints("balances", balances);
    //     // emit log_uints("burnedShells", burnedShells);

    // }

}