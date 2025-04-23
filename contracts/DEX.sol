// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    function transfer(address recipient, uint amount) external returns (bool);
}

contract SimpleDEX {
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint public reserveA;
    uint public reserveB;

    constructor(address _tokenA, address _tokenB) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidity(uint amountA, uint amountB) external {
        require(tokenA.transferFrom(msg.sender, address(this), amountA), "Transfer of tokenA failed");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "Transfer of tokenB failed");

        reserveA += amountA;
        reserveB += amountB;
    }

    function swapAForB(uint amountAIn) external {
        require(tokenA.transferFrom(msg.sender, address(this), amountAIn), "Transfer of tokenA failed");

        uint amountBOut = getAmountOut(amountAIn, reserveA, reserveB);
        require(tokenB.transfer(msg.sender, amountBOut), "Transfer of tokenB failed");

        reserveA += amountAIn;
        reserveB -= amountBOut;
    }

    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) public pure returns (uint) {
        uint amountInWithFee = amountIn * 997;
        uint numerator = amountInWithFee * reserveOut;
        uint denominator = (reserveIn * 1000) + amountInWithFee;
        return numerator / denominator;
    }
}