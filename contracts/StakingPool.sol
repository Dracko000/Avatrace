// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ComplexToken.sol";

contract StakingPool {
    Token public token;
    
    struct Stake {
        uint256 amount;
        uint256 startTime;
        uint256 duration; // in seconds
        bool claimed;
    }
    
    mapping(address => Stake[]) public stakes;
    mapping(address => uint256) public rewards;
    
    uint256 public constant REWARD_RATE = 10; // 10% reward per year
    uint256 public constant SECONDS_PER_YEAR = 365 days;
    
    event StakeCreated(address indexed user, uint256 amount, uint256 duration);
    event RewardClaimed(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    
    constructor(address _tokenAddress) {
        token = Token(_tokenAddress);
    }
    
    function stakeTokens(uint256 _amount, uint256 _duration) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(_duration >= 30 days && _duration <= 365 days, "Duration must be between 30 days and 1 year");
        
        // Transfer tokens from user to this contract
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        
        stakes[msg.sender].push(Stake({
            amount: _amount,
            startTime: block.timestamp,
            duration: _duration,
            claimed: false
        }));
        
        emit StakeCreated(msg.sender, _amount, _duration);
    }
    
    function calculateReward(address _user, uint256 _stakeIndex) public view returns (uint256) {
        Stake memory stake = stakes[_user][_stakeIndex];
        
        if (stake.claimed) {
            return 0;
        }
        
        if (block.timestamp < stake.startTime + stake.duration) {
            return 0; // Stake period not completed yet
        }
        
        // Calculate reward based on amount and time
        uint256 timeElapsed = block.timestamp - stake.startTime;
        uint256 reward = (stake.amount * REWARD_RATE * timeElapsed) / (SECONDS_PER_YEAR * 100);
        
        return reward;
    }
    
    function claimRewards(uint256[] calldata _stakeIndexes) external {
        uint256 totalReward = 0;
        
        for (uint256 i = 0; i < _stakeIndexes.length; i++) {
            uint256 index = _stakeIndexes[i];
            require(index < stakes[msg.sender].length, "Invalid stake index");
            
            uint256 reward = calculateReward(msg.sender, index);
            if (reward > 0) {
                stakes[msg.sender][index].claimed = true;
                totalReward += reward;
            }
        }
        
        if (totalReward > 0) {
            rewards[msg.sender] += totalReward;
            
            // Transfer reward tokens to user
            require(token.transfer(msg.sender, totalReward), "Reward transfer failed");
            
            emit RewardClaimed(msg.sender, totalReward);
        }
    }
    
    function unstake(uint256 _stakeIndex) external {
        require(_stakeIndex < stakes[msg.sender].length, "Invalid stake index");
        Stake storage stake = stakes[msg.sender][_stakeIndex];
        require(!stake.claimed, "Stake already processed");
        
        // Check if staking period is over
        require(block.timestamp >= stake.startTime + stake.duration, "Staking period not completed");
        
        uint256 amount = stake.amount;
        stake.claimed = true; // Mark as processed
        
        // Transfer back the staked tokens
        require(token.transfer(msg.sender, amount), "Unstake transfer failed");
        
        emit Unstaked(msg.sender, amount);
    }
    
    function getUserStakes(address _user) external view returns (Stake[] memory) {
        return stakes[_user];
    }
    
    function getTotalRewards(address _user) external view returns (uint256) {
        return rewards[_user];
    }
}