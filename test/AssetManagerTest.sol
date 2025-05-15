// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/AssetManager.sol";

/**
 * @title AssetManager_Test_WithImpl2
 * @dev AssetManagerコントラクトのテストケースです。(実装2のテストも含む)
 */
contract AssetManager_Test_WithImpl2 is Test {
    AssetManager private assetManager;

    address private alice = address(0x1);
    address private bob = address(0x2);
    address private zeroAddress = address(0x0);

    // --- イベントの再定義 ---
    event AddressRegistered(address indexed user);
    event AssetSet(address indexed user, uint256 amountAdded, uint256 newTotal);
    event AssetWithHashSet( // 実装1用
    address indexed user, uint256 amountAdded, uint256 newTotalAsset, bytes hashValue);
    event AssetWithInternalHashSet( // 実装2用
    address indexed user, uint256 amountAdded, uint256 newTotalAsset, bytes32 calculatedHashValue);

    function setUp() public {
        assetManager = new AssetManager();
    }

    // --- 既存のテスト関数 (registAddress, setAsset, addAssetWithHash, getHashForAssetAmountなど) ---
    // これらは前回のテストコードから流用または微調整

    function test_RegistAddress_Success() public {
        vm.expectEmit(true, false, false, true);
        emit AddressRegistered(alice);
        assetManager.registAddress(alice);
        assertTrue(assetManager.isRegistered(alice));
    }

    function test_SetAsset_Success() public {
        assetManager.registAddress(alice);
        uint256 amount = 100;
        vm.prank(alice);
        vm.expectEmit(true, false, false, true);
        emit AssetSet(alice, amount, amount);
        assetManager.setAsset(amount);
        assertEq(assetManager.getAsset(alice), amount);
    }

    function test_AddAssetWithHash_Success() public {
        // 実装1用
        assetManager.registAddress(alice);
        uint256 amount = 200;
        bytes memory hash1 = hex"1122aabb";
        vm.prank(alice);
        vm.expectEmit(true, false, false, true);
        emit AssetWithHashSet(alice, amount, amount, hash1);
        assetManager.addAssetWithHash(amount, hash1);
        assertEq(assetManager.getAsset(alice), amount);
        assertEq(assetManager.getHashForAssetAmount(alice, amount), hash1);
    }

    // ★★★ 「実装2」のための新しいテスト関数 ★★★

    /**
     * @dev test: addAssetAndCalculateHashInternal - 正常系
     * 資産とファイルデータを登録し、コントラクト内でハッシュが計算・保存されることを確認
     */
    function test_AddAssetAndCalculateHashInternal_Success() public {
        assetManager.registAddress(alice); // 事前にアリスを登録

        uint256 amount1 = 300;
        bytes memory fileData1 = "This is test file data for AssetManager Impl2.";
        bytes32 expectedHash1 = sha256(fileData1); // 期待されるハッシュ値を事前に計算
        uint256 expectedTotalAsset1 = amount1;

        vm.prank(alice); // アリスとして実行
        vm.expectEmit(true, false, false, true); // イベントのトピックとデータ全てをチェック
        emit AssetWithInternalHashSet(alice, amount1, expectedTotalAsset1, expectedHash1);
        assetManager.addAssetAndCalculateHashInternal(amount1, fileData1);

        // 資産額が正しく更新されたか
        assertEq(
            assetManager.getAsset(alice),
            expectedTotalAsset1,
            "Asset amount should be updated after internal hash registration."
        );
        // 保存されたハッシュ値が期待通りか
        assertEq(
            assetManager.getInternalHashForAssetAmount(alice, expectedTotalAsset1),
            expectedHash1,
            "Calculated hash should be stored correctly."
        );

        // 2回目の登録（資産は加算される）
        uint256 amount2 = 250;
        bytes memory fileData2 = "Another file data.";
        bytes32 expectedHash2 = sha256(fileData2);
        uint256 expectedTotalAsset2 = expectedTotalAsset1 + amount2;

        vm.prank(alice);
        vm.expectEmit(true, false, false, true);
        emit AssetWithInternalHashSet(alice, amount2, expectedTotalAsset2, expectedHash2);
        assetManager.addAssetAndCalculateHashInternal(amount2, fileData2);

        assertEq(assetManager.getAsset(alice), expectedTotalAsset2, "Asset amount should be further updated.");
        assertEq(
            assetManager.getInternalHashForAssetAmount(alice, expectedTotalAsset2),
            expectedHash2,
            "New calculated hash should be stored for the new total asset."
        );
        // 前の資産額に対応するハッシュが残っているか（上書きされていないか）
        assertEq(
            assetManager.getInternalHashForAssetAmount(alice, expectedTotalAsset1),
            expectedHash1,
            "Previous hash for previous total asset should remain."
        );
    }

    /**
     * @dev test: addAssetAndCalculateHashInternal - 失敗系: 未登録ユーザー
     */
    function test_AddAssetAndCalculateHashInternal_Fail_Unregistered() public {
        bytes memory fileData = "test data";
        vm.prank(bob); // 未登録のボブ
        vm.expectRevert(bytes("AssetManager: Caller is not a registered address"));
        assetManager.addAssetAndCalculateHashInternal(100, fileData);
    }

    /**
     * @dev test: addAssetAndCalculateHashInternal - 失敗系: 登録額が0
     */
    function test_AddAssetAndCalculateHashInternal_Fail_ZeroAmount() public {
        assetManager.registAddress(alice);
        bytes memory fileData = "test data";
        vm.prank(alice);
        vm.expectRevert(bytes("AssetManager: Amount must be greater than zero"));
        assetManager.addAssetAndCalculateHashInternal(0, fileData);
    }

    /**
     * @dev test: addAssetAndCalculateHashInternal - 失敗系: ファイルデータが空
     */
    function test_AddAssetAndCalculateHashInternal_Fail_EmptyFileData() public {
        assetManager.registAddress(alice);
        bytes memory emptyFileData = ""; // 空のバイト配列
        vm.prank(alice);
        vm.expectRevert(bytes("AssetManager: File data cannot be empty"));
        assetManager.addAssetAndCalculateHashInternal(100, emptyFileData);
    }

    /**
     * @dev test: getInternalHashForAssetAmount - 正常系
     * 登録された内部計算ハッシュが正しく取得できることを確認
     */
    function test_GetInternalHashForAssetAmount_Success() public {
        assetManager.registAddress(alice);
        uint256 amount = 777;
        bytes memory fileData = "data for internal hash getter test";
        bytes32 expectedHash = sha256(fileData);
        uint256 totalAsset = amount;

        vm.prank(alice);
        assetManager.addAssetAndCalculateHashInternal(amount, fileData);

        bytes32 retrievedHash = assetManager.getInternalHashForAssetAmount(alice, totalAsset);
        assertEq(retrievedHash, expectedHash, "Retrieved internal hash should match the stored one.");
    }

    /**
     * @dev test: getInternalHashForAssetAmount - 失敗系: ユーザー未登録
     * (コントラクト内のrequireでリバートされることを期待)
     */
    function test_GetInternalHashForAssetAmount_Fail_UserNotRegistered() public {
        vm.expectRevert(bytes("AssetManager: User is not registered"));
        assetManager.getInternalHashForAssetAmount(bob, 100);
    }

    /**
     * @dev test: getInternalHashForAssetAmount - 該当なしの場合
     * 特定の総資産額に対応するハッシュが登録されていない場合、bytes32(0) が返ることを確認
     */
    function test_GetInternalHashForAssetAmount_NoHashForAmount() public {
        assetManager.registAddress(alice);
        // アリスの資産をセットするが、特定の額に対する内部計算ハッシュは登録しない
        vm.prank(alice);
        assetManager.setAsset(500); // これにより userAssets[alice] は 500 になる

        // 資産額500に対して内部計算ハッシュは登録されていないはず
        bytes32 retrievedHash = assetManager.getInternalHashForAssetAmount(alice, 500);
        assertEq(retrievedHash, bytes32(0), "Hash for amount without specific internal hash set should be bytes32(0).");

        // 存在しない資産額に対しても bytes32(0)
        retrievedHash = assetManager.getInternalHashForAssetAmount(alice, 999);
        assertEq(retrievedHash, bytes32(0), "Hash for non-existent asset amount state should be bytes32(0).");
    }

    // --- 既存のGetter関数のテストも必要に応じて拡充・維持 ---
    // 例: isRegistered, getRegisteredAddresses, getAsset など
    // (多くは既に他のテストケースで間接的にテストされていますが、個別のテストも有効です)

    function test_GetRegisteredAddresses_InitialEmpty() public {
        address[] memory registered = assetManager.getRegisteredAddresses();
        assertEq(registered.length, 0);
    }

    function test_IsRegistered_Unregistered() public {
        assertFalse(assetManager.isRegistered(bob));
    }
}
