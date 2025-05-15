// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol"; // Foundryのテスト用ライブラリ
import "../src/ConditionExample.sol";

contract ConditionExampleTest is Test {
    ConditionExample conditionExample;

    // 各テスト実行前に呼ばれる関数
    function setUp() public {
        conditionExample = new ConditionExample();
    }

    // valueが10未満の場合のテスト
    function testValueLessThan10() public {
        conditionExample.setValue(5);
        string memory result = conditionExample.checkValue();
        assertEq(result, "Value is less than 10", "Error: Value should be less than 10");
        emit log("testValueLessThan10 passed: Value is less than 10 as expected.");
    }

    // valueが10の場合のテスト
    function testValueEqualTo10() public {
        conditionExample.setValue(10);
        string memory result = conditionExample.checkValue();
        assertEq(result, "Value is exactly 10", "Error: Value should be exactly 10");
        emit log("testValueEqualTo10 passed: Value is exactly 10 as expected.");
    }

    // valueが10より大きい場合のテスト
    function testValueGreaterThan10() public {
        conditionExample.setValue(15);
        string memory result = conditionExample.checkValue();
        assertEq(result, "Value is greater than 10", "Error: Value should be greater than 10");
        emit log("testValueGreaterThan10 passed: Value is greater than 10 as expected.");
    }
}
