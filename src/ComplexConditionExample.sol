// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ComplexConditionExample {
    uint256 public value;
    bool public isActive;

    // 値とisActiveフラグを設定する関数
    function setValues(uint256 _value, bool _isActive) public {
        value = _value;
        isActive = _isActive;
    }

    // 複数の条件に応じて異なるメッセージを返す関数
    function checkComplexCondition() public view returns (string memory) {
        if (value < 10 && isActive) {
            return "Value is less than 10 and the contract is active";
        } else if (value >= 10 && value <= 20 && isActive) {
            return "Value is between 10 and 20 and the contract is active";
        } else if ((value > 20 || !isActive) && value < 50) {
            return "Value is greater than 20 or the contract is inactive, but less than 50";
        } else if (value >= 50) {
            return "Value is 50 or greater";
        } else {
            return "No specific condition met";
        }
    }
}
