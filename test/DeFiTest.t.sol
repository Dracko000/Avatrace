// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/WETH9.sol";
import "../contracts/ComplexToken.sol";
import "../contracts/DEXFactory.sol";
import "../contracts/DEXRouter.sol";
import "../contracts/AMMPair.sol";

contract DeFiTest is Test {
    WETH9 public weth;
    Token public tokenA;
    Token public tokenB;
    DEXFactory public factory;
    DEXRouter public router;
    AMMPair public pair;
    
    address public user1 = address(0x123);
    address public user2 = address(0x456);

    function setUp() public {
        weth = new WETH9();
        tokenA = new Token("Token A", "TKNA", 18, 1000000 * 10**18);
        tokenB = new Token("Token B", "TKNB", 18, 1000000 * 10**18);
        factory = new DEXFactory(address(this));
        router = new DEXRouter(address(factory), address(weth));
        
        // Give tokens to test users
        tokenA.transfer(user1, 10000 * 10**18);
        tokenB.transfer(user1, 10000 * 10**18);
        tokenA.transfer(user2, 10000 * 10**18);
        tokenB.transfer(user2, 10000 * 10**18);
    }

    function testDeFiLiquidityAddition() public {
        // Create pair via factory
        address pairAddress = factory.createPair(address(tokenA), address(tokenB));
        pair = AMMPair(pairAddress);
        
        // Approve router to spend tokens
        vm.startPrank(user1);
        tokenA.approve(address(router), 1000 * 10**18);
        tokenB.approve(address(router), 1000 * 10**18);
        
        // Add liquidity
        (uint256 amountA, uint256 amountB, uint256 liquidity) = router.addLiquidity(
            address(tokenA),
            address(tokenB),
            1000 * 10**18,
            1000 * 10**18,
            990 * 10**18,  // minimum amounts
            990 * 10**18,
            user1,
            block.timestamp + 1000
        );
        
        vm.stopPrank();
        
        // Verify liquidity was added
        assertGt(liquidity, 0);
        assertEq(amountA, 1000 * 10**18);
        assertEq(amountB, 1000 * 10**18);
    }

    function testDeFiSwap() public {
        // Create pair via factory
        address pairAddress = factory.createPair(address(tokenA), address(tokenB));
        pair = AMMPair(pairAddress);
        
        // Add initial liquidity
        vm.startPrank(user1);
        tokenA.approve(address(router), 10000 * 10**18);
        tokenB.approve(address(router), 10000 * 10**18);
        
        router.addLiquidity(
            address(tokenA),
            address(tokenB),
            1000 * 10**18,
            1000 * 10**18,
            990 * 10**18,
            990 * 10**18,
            user1,
            block.timestamp + 1000
        );
        vm.stopPrank();
        
        // Perform a swap
        vm.startPrank(user2);
        tokenA.approve(address(router), 100 * 10**18);
        
        address[] memory path = new address[](2);
        path[0] = address(tokenA);
        path[1] = address(tokenB);
        
        uint256[] memory amounts = router.swapExactTokensForTokens(
            100 * 10**18,    // amount in
            90 * 10**18,    // minimum amount out
            path,
            user2,
            block.timestamp + 1000
        );
        
        vm.stopPrank();
        
        // Verify swap happened
        assertGt(amounts[1], 0); // received some tokenB
        assertEq(amounts[0], 100 * 10**18); // sent 100 tokenA
    }
}