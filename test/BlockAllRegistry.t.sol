// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "forge-std/Test.sol";
import {BlockAllRegistry} from "src/BlockAllRegistry.sol";

contract BlockAllRegistryUnitTest is Test {
    BlockAllRegistry public registry;

    function setUp() public {
        registry = new BlockAllRegistry();
    }

    function test_getBlockListStatus(address operator) public {
        bool result = registry.getBlockListStatus(operator);
        assertTrue(result);
    }

    function test_setBlockListStatus(address[] calldata operators, bool status) public {
        vm.expectRevert();
        registry.setBlockListStatus(operators, status);
    }

    function test_clearBlocklist() public {
        vm.expectRevert();
        registry.clearBlockList();
    }
}
