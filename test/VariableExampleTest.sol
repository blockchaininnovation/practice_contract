// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VariableExample.sol";

contract VariableExampleTest is Test {
    VariableExample variableExample;

    // テストの前準備として、コントラクトをデプロイ
    function setUp() public {
        variableExample = new VariableExample(10); // 初期値として10を設定
        emit log("Contract deployed with initial storedNumber = 10");
    }

    // 初期値の確認テスト
    function testInitialStoredNumber() public {
        uint256 expected = 10;
        uint256 actual = variableExample.getStoredNumber();

        if (actual != expected) {
            emit log("Error: Initial storedNumber is not 10");
            assertEq(actual, expected, "Initial storedNumber should be 10");
        } else {
            emit log("Success: Initial storedNumber is correctly set to 10");
        }
    }

    // メンバ変数とローカル変数の違いを確認するテスト
    function testUpdateStoredNumber() public {
        uint256 newNumber = 15;
        variableExample.updateStoredNumber(newNumber);

        uint256 expected = newNumber * 2; // ローカル変数 tempValue により、storedNumber は newNumber * 2 になる
        uint256 actual = variableExample.getStoredNumber();

        if (actual != expected) {
            emit log("Error: storedNumber was not updated correctly");
            assertEq(actual, expected, "storedNumber should be updated to newNumber * 2");
        } else {
            emit log("Success: storedNumber was correctly updated to newNumber * 2");
        }
    }
}
