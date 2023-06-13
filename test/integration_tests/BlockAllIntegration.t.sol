// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import {BlockedOperator} from "../../src/IBlockList.sol";
import {BlockAllRegistry} from "../../src/BlockAllRegistry.sol";
import {BlockListMock} from "../mocks/BlockListMock.sol";

contract BlockAllIntegrationTest is Test {

    BlockListMock public mockContract;

    function setUp() public {
        BlockAllRegistry registry = new BlockAllRegistry();
        mockContract = new BlockListMock(address(registry));
    }

    // Test blocking all registry
    function testNewRegistry(address operator) public {
        vm.expectRevert(BlockedOperator.selector);
        mockContract.setApprovalForAll(operator, true);
    }

}