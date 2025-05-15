// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol"; // Foundryのテスト用ライブラリ
import "../src/ArrayLoopExample.sol";

contract ArrayLoopExampleTest is Test {
    ArrayLoopExample arrayLoopExample;

    // テストのセットアップ
    function setUp() public {
        arrayLoopExample = new ArrayLoopExample();
    }

    // 配列に数値を追加し、合計が正しく計算されているかを確認するテスト
    function testCalculateSum() public {
        // 配列に数値を追加
        arrayLoopExample.addNumber(1);
        arrayLoopExample.addNumber(2);
        arrayLoopExample.addNumber(3);
        arrayLoopExample.addNumber(4);
        arrayLoopExample.addNumber(5);

        // 合計を計算し、期待値と比較
        uint256 expectedSum = 1 + 2 + 3 + 4 + 5; // 15
        uint256 calculatedSum = arrayLoopExample.calculateSum();
        assertEq(calculatedSum, expectedSum, "Error: The calculated sum should be 15.");

        // 結果が正しい場合にログを出力
        emit log("testCalculateSum passed: The calculated sum is 15 as expected.");
    }

    // 空の配列の場合のテスト
    function testCalculateSumEmptyArray() public {
        // 合計を計算し、期待値と比較
        uint256 expectedSum = 0;
        uint256 calculatedSum = arrayLoopExample.calculateSum();
        assertEq(calculatedSum, expectedSum, "Error: The calculated sum should be 0 for an empty array.");

        // 結果が正しい場合にログを出力
        emit log("testCalculateSumEmptyArray passed: The calculated sum is 0 as expected for an empty array.");
    }

    // 大きな数値を含む配列の合計をテスト
    function testCalculateSumWithLargeNumbers() public {
        // 配列に大きな数値を追加
        arrayLoopExample.addNumber(100);
        arrayLoopExample.addNumber(200);
        arrayLoopExample.addNumber(300);

        // 合計を計算し、期待値と比較
        uint256 expectedSum = 100 + 200 + 300; // 600
        uint256 calculatedSum = arrayLoopExample.calculateSum();
        assertEq(calculatedSum, expectedSum, "Error: The calculated sum should be 600.");

        // 結果が正しい場合にログを出力
        emit log("testCalculateSumWithLargeNumbers passed: The calculated sum is 600 as expected.");
    }
}
