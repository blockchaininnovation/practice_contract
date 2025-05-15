// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserStorage {
    // ユーザー情報を表す構造体
    struct User {
        string name;
        address userAddress;
    }

    // ユーザーのアドレスをキーにして、ユーザー情報を保存するマッピング
    mapping(address => User) private users;

    // ユーザー情報を登録する関数
    function addUser(string memory _name) public {
        users[msg.sender] = User({name: _name, userAddress: msg.sender});
    }

    // ユーザー情報を取得する関数
    function getUser(address _userAddress) public view returns (string memory name, address userAddress) {
        User memory user = users[_userAddress];
        return (user.name, user.userAddress);
    }

    // ユーザー情報が登録されているか確認する関数
    function userExists(address _userAddress) public view returns (bool) {
        return bytes(users[_userAddress].name).length > 0;
    }
}
