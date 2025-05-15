// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol"; // Foundryのテスト用ライブラリ
import "../src/ComplexConditionExample.sol";

contract ComplexConditionExampleTest is Test {
    ComplexConditionExample complexConditionExample;

    // 各テストのセットアップ
    function setUp() public {
        complexConditionExample = new ComplexConditionExample();
    }

    // valueが10未満かつisActiveがtrueの場合のテスト
    function testValueLessThan10AndActive() public {
        complexConditionExample.setValues(5, true);
        string memory result = complexConditionExample.checkComplexCondition();
        assertEq(
            result,
            "Value is less than 10 and the contract is active",
            "Error: Expected result for value < 10 and active."
        );
        emit log("testValueLessThan10AndActive passed: Value is less than 10 and contract is active as expected.");
    }

    // valueが10以上20以下でかつisActiveがtrueの場合のテスト
    function testValueBetween10And20AndActive() public {
        complexConditionExample.setValues(15, true);
        string memory result = complexConditionExample.checkComplexCondition();
        assertEq(
            result,
            "Value is between 10 and 20 and the contract is active",
            "Error: Expected result for 10 <= value <= 20 and active."
        );
        emit log(
            "testValueBetween10And20AndActive passed: Value is between 10 and 20 and contract is active as expected."
        );
    }

    // valueが20より大きい、またはisActiveがfalseでかつvalueが50未満の場合のテスト
    function testValueGreaterThan20OrInactiveAndLessThan50() public {
        complexConditionExample.setValues(25, false);
        string memory result = complexConditionExample.checkComplexCondition();
        assertEq(
            result,
            "Value is greater than 20 or the contract is inactive, but less than 50",
            "Error: Expected result for value > 20 or inactive, but < 50."
        );
        emit log(
            "testValueGreaterThan20OrInactiveAndLessThan50 passed: Value is greater than 20 or inactive, but less than 50 as expected."
        );
    }

    // valueが50以上の場合のテスト
    function testValueGreaterThanOrEqualTo50() public {
        complexConditionExample.setValues(55, true);
        string memory result = complexConditionExample.checkComplexCondition();
        assertEq(result, "Value is 50 or greater", "Error: Expected result for value >= 50.");
        emit log("testValueGreaterThanOrEqualTo50 passed: Value is 50 or greater as expected.");
    }

    // 条件に該当しない場合のテスト
    function testNoSpecificConditionMet() public {
        // noSpecificConditionMetになる条件はないのでコメントアウト

        // complexConditionExample.setValues(9, false);
        // string memory result = complexConditionExample.checkComplexCondition();
        // assertEq(
        //     result,
        //     "No specific condition met",
        //     "Error: Expected result for no specific condition met."
        // );
        // emit log(
        //     "testNoSpecificConditionMet passed: No specific condition met as expected."
        // );
    }
}
