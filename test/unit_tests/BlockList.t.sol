// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import {Unauthorized, BlockedOperator} from "../../src/IBlockList.sol";
import {BlockListMock} from "../mocks/BlockListMock.sol";

contract BlockListUnitTest is Test {

    BlockListMock public mockContract;

    function setUp() public {
        mockContract = new BlockListMock(address(0));
    }

    function testInitialization() public {
        assertTrue(mockContract.isBlockListAdmin(address(this)));
        assertEq(address(mockContract.blockListRegistry()), address(0));
    }

    /// @dev test to ensure the try/catch works as intended
    function testZeroAddressRegistry(address operator) public {
        assertFalse(mockContract.getBlockListStatus(operator));
    }
}