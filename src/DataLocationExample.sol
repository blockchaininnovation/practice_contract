// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DataLocationExample {
    // Storage変数（コントラクトの状態変数としてブロックチェーン上に保存される）
    uint256[] public storedArray;

    // コンストラクタ
    constructor() {
        // 初期値を設定
        storedArray.push(1);
        storedArray.push(2);
        storedArray.push(3);
    }

    // storageとmemoryの違いを示す関数
    function modifyWithStorage() public {
        // storageを使うことで、コントラクトの状態変数storedArrayが直接更新される
        uint256[] storage storageArray = storedArray;
        storageArray[0] = 100; // storedArray[0]が100に変更される
    }

    function modifyWithMemory() public view returns (uint256[] memory) {
        // memoryを使うことで、storedArrayのコピーが生成され、コントラクトの状態は変更されない
        uint256[] memory memoryArray = storedArray;
        memoryArray[0] = 200; // storedArrayには影響がない
        return memoryArray; // 変更されたコピーを返す
    }

    // calldataの違いを示す関数
    function modifyWithCalldata(uint256[] calldata inputArray) public pure returns (uint256) {
        // calldataは関数引数として読み取り専用で使用され、直接変更できない
        // inputArray[0] = 300; // エラー: calldataは変更できない

        return inputArray[0]; // 読み取り専用として使用
    }

    // 現在のstoredArrayを取得する関数
    function getStoredArray() public view returns (uint256[] memory) {
        return storedArray;
    }
}
