// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConditionExample {
    uint256 public value;

    // 値を設定する関数
    function setValue(uint256 _value) public {
        value = _value;
    }

    // 条件に応じて異なる処理を行う関数
    function checkValue() public view returns (string memory) {
        if (value < 10) {
            return "Value is less than 10";
        } else if (value == 10) {
            return "Value is exactly 10";
        } else {
            return "Value is greater than 10";
        }
    }
}
