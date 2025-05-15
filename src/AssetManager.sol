// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console.sol";

/**
 * @title AssetManager
 * @dev コントラクトにアドレスを登録し、登録済みアドレスの資産と関連ハッシュ値を管理します。
 * 実装1 (フロントエンドでハッシュ計算) と 実装2 (コントラクト内でハッシュ計算) の両方の機能を含みます。
 */
contract AssetManager {
    // --- 状態変数 ---
    address[] private registeredAddresses;
    mapping(address => bool) private isAddressRegistered;
    mapping(address => uint256) public userAssets;

    // --- 実装1用: フロントエンドから渡されたハッシュ (bytes) を保存 ---
    mapping(address => mapping(uint256 => bytes)) public assetStateToHashMap;

    // ★★★ 実装2用: コントラクト内で計算したハッシュ (bytes32) を保存 ★★★
    mapping(address => mapping(uint256 => bytes32)) public assetStateToInternalHashMap;

    // --- イベント ---
    event AddressRegistered(address indexed user);
    event AssetSet(address indexed user, uint256 amountAdded, uint256 newTotal);
    event AssetWithHashSet( // 実装1用イベント
    address indexed user, uint256 amountAdded, uint256 newTotalAsset, bytes hashValue);

    // ★★★ 実装2用: 新しいイベント ★★★
    event AssetWithInternalHashSet(
        address indexed user, uint256 amountAdded, uint256 newTotalAsset, bytes32 calculatedHashValue
    );

    function registAddress(address addr) public {
        require(addr != address(0), "AssetManager: Cannot register the zero address");
        require(!isAddressRegistered[addr], "AssetManager: Address is already registered");
        registeredAddresses.push(addr);
        isAddressRegistered[addr] = true;
        console.log("Address registered:", addr);
        emit AddressRegistered(addr);
    }

    function setAsset(uint256 _amount) public {
        require(isAddressRegistered[msg.sender], "AssetManager: Caller is not a registered address");
        require(_amount > 0, "AssetManager: Amount must be greater than zero");
        uint256 currentAmount = userAssets[msg.sender];
        uint256 newTotalAmount = currentAmount + _amount;
        userAssets[msg.sender] = newTotalAmount;
        console.log("--- Asset Set ---");
        console.log("User:", msg.sender);
        console.log("Amount Added:", _amount);
        console.log("New Total:", newTotalAmount);
        console.log("--- End Asset Set ---");
        emit AssetSet(msg.sender, _amount, newTotalAmount);
    }

    function addAssetWithHash(uint256 _amount, bytes calldata _hashvalue) public {
        // 実装1用
        require(isAddressRegistered[msg.sender], "AssetManager: Caller is not a registered address");
        require(_amount > 0, "AssetManager: Amount must be greater than zero");
        require(_hashvalue.length > 0, "AssetManager: Hash value cannot be empty");
        uint256 currentTotalAsset = userAssets[msg.sender];
        uint256 newTotalAsset = currentTotalAsset + _amount;
        userAssets[msg.sender] = newTotalAsset;
        assetStateToHashMap[msg.sender][newTotalAsset] = _hashvalue;
        console.log("--- Asset With Hash Set (Frontend Calc) ---");
        console.log("User:", msg.sender);
        console.log("Amount Added:", _amount);
        console.log("New Total Asset:", newTotalAsset);
        if (_hashvalue.length >= 32) {
            console.log("Hash Value (first 32 bytes):");
            console.logBytes32(bytes32(slice(_hashvalue, 0, 32)));
        } else {
            console.log("Hash Value (less than 32 bytes, full value):");
            console.logBytes(_hashvalue);
        }
        console.log("--- End Asset With Hash Set (Frontend Calc) ---");
        emit AssetWithHashSet(msg.sender, _amount, newTotalAsset, _hashvalue);
    }

    // ★★★ 実装2用: 新しい関数 ★★★
    function addAssetAndCalculateHashInternal(uint256 _amount, bytes memory _fileData) public {
        require(isAddressRegistered[msg.sender], "AssetManager: Caller is not a registered address");
        require(_amount > 0, "AssetManager: Amount must be greater than zero");
        require(_fileData.length > 0, "AssetManager: File data cannot be empty");

        uint256 currentTotalAsset = userAssets[msg.sender];
        uint256 newTotalAsset = currentTotalAsset + _amount;
        userAssets[msg.sender] = newTotalAsset;

        bytes32 calculatedHash = sha256(_fileData);
        assetStateToInternalHashMap[msg.sender][newTotalAsset] = calculatedHash;

        console.log("--- Asset With Internal Hash Set (Contract Calc) ---");
        console.log("User:", msg.sender);
        console.log("Amount Added:", _amount);
        console.log("New Total Asset:", newTotalAsset);
        console.logBytes32(calculatedHash);
        console.log("--- End Asset With Internal Hash Set (Contract Calc) ---");
        emit AssetWithInternalHashSet(msg.sender, _amount, newTotalAsset, calculatedHash);
    }

    function getRegisteredAddresses() public view returns (address[] memory) {
        return registeredAddresses;
    }

    function isRegistered(address addr) public view returns (bool) {
        return isAddressRegistered[addr];
    }

    function getAsset(address _user) public view returns (uint256) {
        return userAssets[_user];
    }

    function getHashForAssetAmount(address _user, uint256 _totalAsset) public view returns (bytes memory) {
        // 実装1用
        require(isAddressRegistered[_user], "AssetManager: User is not registered");
        return assetStateToHashMap[_user][_totalAsset];
    }

    // ★★★ 実装2用: 新しいGetter関数 ★★★
    function getInternalHashForAssetAmount(address _user, uint256 _totalAsset) public view returns (bytes32) {
        require(isAddressRegistered[_user], "AssetManager: User is not registered");
        return assetStateToInternalHashMap[_user][_totalAsset];
    }

    function slice(bytes memory b, uint256 start, uint256 length) internal pure returns (bytes memory) {
        require(b.length >= start + length, "Slice: out of bounds");
        bytes memory result = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = b[start + i];
        }
        return result;
    }
}
