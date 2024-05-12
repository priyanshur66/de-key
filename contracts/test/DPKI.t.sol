// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "forge-std/Test.sol";
import {DPKIContract} from "../src/DPKI.sol";

contract DPKIContractTest is Test {
    DPKIContract public dpkiContract;

    function setUp() public {
        dpkiContract = new DPKIContract();
    }

    function test_All() public {}
}
