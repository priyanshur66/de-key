// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "forge-std/Script.sol";
import {DPKIContract} from "../src/DPKI.sol";

contract DPKIScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        new DPKIContract();
        vm.stopBroadcast();
    }

    // It is a hack to exlcude this file from foundry forge code coverage report.
    function test() public {}
}
