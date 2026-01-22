// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/ComplexToken.sol";
import "../contracts/StakingPool.sol";

contract ComplexContractsTest is Test {
    Token public token;
    StakingPool public stakingPool;
    address public user1 = address(0x123);
    address public user2 = address(0x456);

    function setUp() public {
        token = new Token("Test Token", "TTK", 18, 1000000 * 10**18);
        stakingPool = new StakingPool(address(token));
        
        // Give some tokens to test users
        vm.prank(address(token.owner()));
        token.transfer(user1, 10000 * 10**18);
        vm.prank(address(token.owner()));
        token.transfer(user2, 10000 * 10**18);
    }

    function testComplexStakingFlow() public {
        vm.startPrank(user1);

        // Approve staking pool to spend tokens
        token.approve(address(stakingPool), 5000 * 10**18);

        // Stake tokens
        stakingPool.stakeTokens(1000 * 10**18, 30 days);
        stakingPool.stakeTokens(2000 * 10**18, 60 days);

        vm.stopPrank();

        // Advance time to allow rewards
        vm.warp(block.timestamp + 90 days);

        vm.startPrank(user1);

        // Unstake the first stake (after 90 days, 30-day stake is eligible)
        stakingPool.unstake(0);

        // Claim rewards for the second stake (60-day stake after 90 days)
        uint256[] memory stakeIndexes = new uint256[](1);
        stakeIndexes[0] = 1;
        stakingPool.claimRewards(stakeIndexes);

        vm.stopPrank();

        // Verify balances and stakes
        assertGt(token.balanceOf(user1), 7000 * 10**18); // Should have more than initial minus staked due to rewards
    }

    function testMultipleUsersStaking() public {
        // User 1 stakes
        vm.startPrank(user1);
        token.approve(address(stakingPool), 5000 * 10**18);
        stakingPool.stakeTokens(1000 * 10**18, 30 days);
        vm.stopPrank();
        
        // User 2 stakes
        vm.startPrank(user2);
        token.approve(address(stakingPool), 5000 * 10**18);
        stakingPool.stakeTokens(2000 * 10**18, 45 days);
        vm.stopPrank();
        
        // Advance time
        vm.warp(block.timestamp + 100 days);
        
        // Both users claim rewards
        vm.startPrank(user1);
        uint256[] memory stakeIndexes1 = new uint256[](1);
        stakeIndexes1[0] = 0;
        stakingPool.claimRewards(stakeIndexes1);
        vm.stopPrank();
        
        vm.startPrank(user2);
        uint256[] memory stakeIndexes2 = new uint256[](1);
        stakeIndexes2[0] = 0;
        stakingPool.claimRewards(stakeIndexes2);
        vm.stopPrank();
        
        // Verify both users got rewards
        assertTrue(stakingPool.getTotalRewards(user1) > 0);
        assertTrue(stakingPool.getTotalRewards(user2) > 0);
    }
}