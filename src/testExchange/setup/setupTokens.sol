


pragma solidity ^0.5.6;

import "ds-test/test.sol";
import "../../ERC20Token.sol";
import "./setupPool.sol";

contract TokenSetup is PoolSetup {

    ERC20Token testA;
    ERC20Token testB;
    ERC20Token testC;
    ERC20Token testD;
    ERC20Token testE;
    ERC20Token testF;
    ERC20Token testG;
    ERC20Token testH;
    ERC20Token testI;
    ERC20Token testJ;
    ERC20Token testK;
    ERC20Token testL;
    ERC20Token testM;
    ERC20Token testN;
    ERC20Token testO;
    ERC20Token testP;
    ERC20Token testQ;
    ERC20Token testR;

    function setupTokens () public {
        uint256 tokenAmount = 1000000000 * (10 ** 18);
        testA = new ERC20Token("test a", "TESTA", 18, tokenAmount);
        testB = new ERC20Token("test b", "TESTB", 17, tokenAmount);
        testC = new ERC20Token("test c", "TESTC", 16, tokenAmount);
        testD = new ERC20Token("test d", "TESTD", 15, tokenAmount);
        testE = new ERC20Token("test e", "TESTE", 14, tokenAmount);
        testF = new ERC20Token("test f", "TESTF", 13, tokenAmount);
        testG = new ERC20Token("test g", "TESTG", 12, tokenAmount);
        testH = new ERC20Token("test h", "TESTH", 11, tokenAmount);
        testI = new ERC20Token("test i", "TESTI", 10, tokenAmount);
        testJ = new ERC20Token("test j", "TESTJ", 9, tokenAmount);
        testK = new ERC20Token("test k", "TESTK", 8, tokenAmount);
        testL = new ERC20Token("test l", "TESTL", 7, tokenAmount);
        testM = new ERC20Token("test m", "TESTM", 6, tokenAmount);
        testN = new ERC20Token("test n", "TESTN", 5, tokenAmount);
        testO = new ERC20Token("test o", "TESTO", 4, tokenAmount);
        testP = new ERC20Token("test p", "TESTP", 3, tokenAmount);
        testQ = new ERC20Token("test q", "TESTQ", 2, tokenAmount);
        testR = new ERC20Token("test r", "TESTR", 1, tokenAmount);

        testA.approve(address(pool), tokenAmount);
        testB.approve(address(pool), tokenAmount);
        testC.approve(address(pool), tokenAmount);
        testD.approve(address(pool), tokenAmount);
        testE.approve(address(pool), tokenAmount);
        testF.approve(address(pool), tokenAmount);
        testG.approve(address(pool), tokenAmount);
        testH.approve(address(pool), tokenAmount);
        testI.approve(address(pool), tokenAmount);
        testJ.approve(address(pool), tokenAmount);
        testK.approve(address(pool), tokenAmount);
        testL.approve(address(pool), tokenAmount);
        testM.approve(address(pool), tokenAmount);
        testN.approve(address(pool), tokenAmount);
        testO.approve(address(pool), tokenAmount);
        testP.approve(address(pool), tokenAmount);
        testQ.approve(address(pool), tokenAmount);

    }
}