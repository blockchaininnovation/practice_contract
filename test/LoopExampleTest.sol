// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol"; // Foundryのテスト用ライブラリ
import "../src/LoopExample.sol";

contract LoopExampleTest is Test {
    LoopExample loopExample;

    // テストのセットアップ
    function setUp() public {
        loopExample = new LoopExample();
    }

    // 1から10までの合計が正しく計算されているかを確認するテスト
    function testCalculateSum() public {
        uint256 expectedSum = 55; // 1 + 2 + ... + 10 = 55
        uint256 calculatedSum = loopExample.sum();
        assertEq(calculatedSum, expectedSum, "Error: The calculated sum should be 55.");
        emit log("testCalculateSum passed: The calculated sum is 55 as expected.");
    }

    // calculateSum関数単体のテスト
    function testCalculateSumFunction() public {
        uint256 expectedSum = 55; // 1 + 2 + ... + 10 = 55
        uint256 calculatedSum = loopExample.calculateSum();
        assertEq(calculatedSum, expectedSum, "Error: The calculateSum function should return 55.");
        emit log("testCalculateSumFunction passed: The calculateSum function returns 55 as expected.");
    }
}
