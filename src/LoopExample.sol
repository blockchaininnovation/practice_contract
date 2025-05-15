// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoopExample {
    uint256 public sum;

    // コンストラクタで1から10までの合計を計算
    constructor() {
        sum = calculateSum();
    }

    // 1から10までの合計を計算する関数
    function calculateSum() public pure returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 1; i <= 10; i++) {
            total += i;
        }
        return total;
    }
}
