// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/UserStorage.sol";

contract UserStorageTest is Test {
    UserStorage userStorage;

    // テストの前準備として、コントラクトをデプロイ
    function setUp() public {
        userStorage = new UserStorage();
        emit log_string("UserStorage contract deployed.");
    }

    // ユーザー情報の保存を確認するテスト
    function testAddUser() public {
        // 名前の設定
        string memory testName = "Alice";

        // アカウント0でユーザーを追加
        vm.prank(address(0x1));
        userStorage.addUser(testName);

        // ユーザーが正しく追加されているか確認
        (string memory retrievedName, address retrievedAddress) = userStorage.getUser(address(0x1));
        bool userExists = userStorage.userExists(address(0x1));

        if (!userExists) {
            emit log_string("Error: User does not exist after calling addUser.");
            assertEq(userExists, true, "User should exist after addUser is called.");
        } else {
            emit log_string("Success: User exists after calling addUser.");
        }

        // 取得した名前とアドレスが正しいか確認
        if (keccak256(abi.encodePacked(retrievedName)) != keccak256(abi.encodePacked(testName))) {
            emit log_string("Error: Retrieved name does not match the expected name.");
            assertEq(retrievedName, testName, "Retrieved name should match the added name.");
        } else {
            emit log_string("Success: Retrieved name matches the expected name.");
        }

        if (retrievedAddress != address(0x1)) {
            emit log_string("Error: Retrieved address does not match the expected address.");
            assertEq(retrievedAddress, address(0x1), "Retrieved address should match the added address.");
        } else {
            emit log_string("Success: Retrieved address matches the expected address.");
        }
    }
}
