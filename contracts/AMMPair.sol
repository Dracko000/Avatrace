// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ComplexToken.sol";

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction underflow");
        return a - b;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }
}

contract AMMPair {
    using SafeMath for uint256;

    string public constant name = "Avalanche LP Token";
    string public constant symbol = "ALP";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events for ERC20
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    // Reserves of token0 and token1
    uint256 public reserve0;
    uint256 public reserve1;
    
    // Tokens in the pair
    address public token0;
    address public token1;
    
    uint256 public constant FEE_DENOMINATOR = 10000;
    uint256 public constant FEE_NUMERATOR = 30; // 0.3% fee
    
    event Mint(address indexed sender, uint256 amount);
    event Burn(address indexed sender, uint256 amount0, uint256 amount1);
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint256 reserve0, uint256 reserve1);
    
    // Storage for initialization flag
    bool private initialized = false;

    function initialize(address _token0, address _token1) external {
        require(!initialized, "Already initialized");
        require(_token0 != _token1, "IDENTICAL_ADDRESSES");
        token0 = _token0;
        token1 = _token1;
        initialized = true;
    }
    
    // Get the reserves of both tokens
    function getReserves() public view returns (uint256 _reserve0, uint256 _reserve1) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
    }
    
    // Update reserves after a trade
    function _update(uint256 balance0, uint256 balance1) private {
        reserve0 = balance0;
        reserve1 = balance1;
        emit Sync(reserve0, reserve1);
    }
    
    // Mint liquidity tokens
    function mint(address to) external returns (uint256 liquidity) {
        (uint256 _reserve0, uint256 _reserve1) = getReserves(); // gas savings
        uint256 balance0 = Token(token0).balanceOf(address(this));
        uint256 balance1 = Token(token1).balanceOf(address(this));
        uint256 amount0 = balance0.sub(_reserve0);
        uint256 amount1 = balance1.sub(_reserve1);

        uint256 liquidityBefore = totalSupply; // cache for gas savings
        if (liquidityBefore == 0) {
            liquidity = sqrt(amount0.mul(amount1)).sub(1000); // permanently lock the first 1000 tokens
            totalSupply = liquidity;
        } else {
            liquidity = min(
                amount0.mul(totalSupply) / _reserve0,
                amount1.mul(totalSupply) / _reserve1
            );
            totalSupply = liquidityBefore.add(liquidity);
        }
        
        balanceOf[to] = balanceOf[to].add(liquidity);
        _update(balance0, balance1);
        emit Mint(to, liquidity);
    }
    
    // Burn liquidity tokens
    function burn(address to) external returns (uint256 amount0, uint256 amount1) {
        (uint256 _reserve0, uint256 _reserve1) = getReserves(); // gas savings
        address _token0 = token0; // gas savings
        address _token1 = token1; // gas savings
        uint256 liquidity = balanceOf[address(this)];
        
        uint256 liquidityBefore = totalSupply; // gas savings
        amount0 = liquidity.mul(_reserve0) / liquidityBefore;
        amount1 = liquidity.mul(_reserve1) / liquidityBefore;
        
        require(amount0 > 0 && amount1 > 0, "INSUFFICIENT_LIQUIDITY_BURNED");
        
        totalSupply = liquidityBefore.sub(liquidity);
        balanceOf[to] = balanceOf[to].add(amount0);
        balanceOf[to] = balanceOf[to].add(amount1);
        
        Token(_token0).transfer(to, amount0);
        Token(_token1).transfer(to, amount1);
        
        (uint256 _balance0, uint256 _balance1) = (Token(_token0).balanceOf(address(this)), Token(_token1).balanceOf(address(this)));
        _update(_balance0, _balance1);
        emit Burn(msg.sender, amount0, amount1);
    }
    
    // Swap tokens
    function swap(uint256 amount0Out, uint256 amount1Out, address to) external {
        require(amount0Out > 0 || amount1Out > 0, "INSUFFICIENT_OUTPUT_AMOUNT");
        (uint256 _reserve0, uint256 _reserve1) = getReserves(); // gas savings
        require(amount0Out < _reserve0 && amount1Out < _reserve1, "INSUFFICIENT_LIQUIDITY");

        // Transfer tokens out
        if (amount0Out > 0) Token(token0).transfer(to, amount0Out); // optimistically transfer tokens
        if (amount1Out > 0) Token(token1).transfer(to, amount1Out); // optimistically transfer tokens

        uint256 balance0 = Token(token0).balanceOf(address(this));
        uint256 balance1 = Token(token1).balanceOf(address(this));

        uint256 amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
        uint256 amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
        require(amount0In > 0 || amount1In > 0, "INSUFFICIENT_INPUT_AMOUNT");

        // Calculate fees
        uint256 kLast = _reserve0.mul(_reserve1); // gas savings
        uint256 numerator = amount0In.mul(FEE_DENOMINATOR).mul(_reserve1);
        uint256 denominator = _reserve0.mul(FEE_DENOMINATOR).add(amount0In.mul(FEE_NUMERATOR));
        uint256 amount1OutCalculated = numerator / denominator;
        require(amount1OutCalculated >= amount1Out, "K");

        numerator = amount1In.mul(FEE_DENOMINATOR).mul(_reserve0);
        denominator = _reserve1.mul(FEE_DENOMINATOR).add(amount1In.mul(FEE_NUMERATOR));
        uint256 amount0OutCalculated = numerator / denominator;
        require(amount0OutCalculated >= amount0Out, "K");

        _update(balance0.sub(amount0Out), balance1.sub(amount1Out));
        emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
    }
    
    // Helper functions
    function sqrt(uint256 y) private pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
    
    function min(uint256 x, uint256 y) private pure returns (uint256 z) {
        z = x < y ? x : y;
    }

    // ERC20 functions
    function transfer(address dst, uint256 amount) external returns (bool) {
        _transfer(msg.sender, dst, amount);
        return true;
    }

    function transferFrom(address src, address dst, uint256 amount) external returns (bool) {
        uint256 spenderAllowance = allowance[src][msg.sender];
        if (spenderAllowance != type(uint256).max) {
            require(spenderAllowance >= amount, "INSUFFICIENT_ALLOWANCE");
            allowance[src][msg.sender] = spenderAllowance.sub(amount);
        }

        _transfer(src, dst, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function _transfer(address src, address dst, uint256 amount) internal {
        require(balanceOf[src] >= amount, "INSUFFICIENT_BALANCE");
        balanceOf[src] = balanceOf[src].sub(amount);
        balanceOf[dst] = balanceOf[dst].add(amount);
        emit Transfer(src, dst, amount);
    }
}