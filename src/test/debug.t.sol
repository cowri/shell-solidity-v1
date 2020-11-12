
pragma solidity ^0.5.0;

import "ds-test/test.sol";
import "ds-math/math.sol";

import "./setup/setup.sol";

import "./setup/methods.sol";

import "abdk-libraries-solidity/ABDKMath64x64.sol";

contract DebugTest is Setup, DSMath, DSTest {

    using ABDKMath64x64 for uint;
    using ABDKMath64x64 for int128;

    using ShellMethods for Shell;

    Shell s;

    function setUp() public {

        s = getShellSuiteNineMainnet();

    }

    function testDebug () public {
        
        s.ousdOptIn();
        s.ousdOptOut();
        
        uint ousdbal = ousd.balanceOf(address(this));
        uint usdcbal = usdc.balanceOf(address(this));
        uint usdtbal = usdt.balanceOf(address(this));
        
        uint sminted = s.deposit(
            address(ousd), 5e18,
            address(usdc), 2e6,
            address(usdt), 3e6
        );
        
        uint ousdbalprime = ousd.balanceOf(address(this));
        uint usdcbalprime = usdc.balanceOf(address(this));
        uint usdtbalprime = usdt.balanceOf(address(this));
        
        assertTrue(ousdbal - ousdbalprime == 5e18);
        assertTrue(usdcbal - usdcbalprime == 2e6);
        assertTrue(usdtbal - usdtbalprime == 3e6);
        
        uint sburnt = s.withdraw(
            address(ousd), 1e18
        );

        ousdbalprime = ousd.balanceOf(address(this));

        assertTrue(ousdbal - ousdbalprime == 4e18);
        
        uint _usdt = s.originSwap(
            address(ousd),
            address(usdt),
            1e18
        );
        
        usdtbalprime = usdt.balanceOf(address(this));

        assertEq(usdtbal - usdtbalprime + _usdt, 3e6 + _usdt);
        
        uint __usdt = s.originSwap(
            address(usdt),
            address(usdt),
            1e6
        );
        uint usdtbalprimeprime = usdt.balanceOf(address(this));
        
        assertEq(usdtbalprime, usdtbalprimeprime);
        
        emit log_named_uint("yes", _usdt);

        emit log_named_uint("usdt to usdt", __usdt);
        
    }
    
    function testMath () public {


    }

}