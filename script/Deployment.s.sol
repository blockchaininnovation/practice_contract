// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/AssetManager.sol";

contract Deployment is Script {
    function run() external returns (AssetManager) {
        // ← 変更(推奨): 戻り値の型を AssetManager に (必要に応じて)
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY"); // .env から秘密鍵を読み込む
        vm.startBroadcast(deployerPrivateKey);

        AssetManager assetManager = new AssetManager();

        vm.stopBroadcast();

        bytes memory encodedData =
            abi.encodePacked("deployed AssetManager address: ", vm.toString(address(assetManager)));
        console.log(string(encodedData));

        // return assetManager; // 上で returns (AssetManager) を指定した場合
    }
}
