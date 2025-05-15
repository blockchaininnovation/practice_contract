// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VariableExample {
    // メンバ変数（状態変数）
    uint256 public storedNumber;

    // コンストラクタ
    constructor(uint256 initialNumber) {
        storedNumber = initialNumber;
    }

    // メンバ変数を更新する関数
    function updateStoredNumber(uint256 newNumber) public {
        // ローカル変数
        uint256 tempValue = newNumber * 2;

        // メンバ変数 storedNumber をローカル変数 tempValue の値で更新
        storedNumber = tempValue;
    }

    // メンバ変数の値を取得する関数
    function getStoredNumber() public view returns (uint256) {
        return storedNumber;
    }
}
