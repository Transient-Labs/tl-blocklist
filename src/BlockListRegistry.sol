// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.17;

/**
 * ____        _ __    __   ____  _ ________                     __
 *    / __ )__  __(_) /___/ /  / __ \(_) __/ __/__  ________  ____  / /_
 *   / __  / / / / / / __  /  / / / / / /_/ /_/ _ \/ ___/ _ \/ __ \/ __/
 *  / /_/ / /_/ / / / /_/ /  / /_/ / / __/ __/  __/ /  /  __/ / / / /_
 * /_____/\__,_/_/_/\__,_/  /_____/_/_/ /_/  \___/_/   \___/_/ /_/\__/
 */

import {ERC165Upgradeable} from "openzeppelin-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import {OwnableAccessControlUpgradeable} from "tl-sol-tools/upgradeable/access/OwnableAccessControlUpgradeable.sol";
import {IBlockListRegistry} from "./IBlockListRegistry.sol";

/// @title BlockList
/// @notice abstract contract that can be inherited to block
///         approvals from non-royalty paying marketplaces
/// @author transientlabs.xyz
contract BlockListRegistry is IBlockListRegistry, OwnableAccessControlUpgradeable, ERC165Upgradeable {
    /*//////////////////////////////////////////////////////////////////////////
                               Private State Variables
    //////////////////////////////////////////////////////////////////////////*/

    uint256 private _c; // variable that allows reset for `_blockList`
    mapping(uint256 => mapping(address => bool)) private _blockList;

    /*//////////////////////////////////////////////////////////////////////////
                                Modifiers
    //////////////////////////////////////////////////////////////////////////*/

    /// @dev modifier to gate setter functions
    modifier isBlockListOwner() {
        if (msg.sender != owner()) {
            revert NotBlockListOwner();
        }
        _;
    }

    /*//////////////////////////////////////////////////////////////////////////
                                Constructor
    //////////////////////////////////////////////////////////////////////////*/
    function initialize(address newOwner, address[] memory initBlockList) external initializer {
        for (uint8 i = 0; i < initBlockList.length; i++) {
            _setBlockListStatus(initBlockList[i], true);
        }
        __OwnableAccessControl_init(newOwner);
    }

    /*//////////////////////////////////////////////////////////////////////////
                            Admin Functions
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice function to clear the block list status
    /// @dev must be called by the blockList owner
    /// @dev the blockList owner is likely the same as the owner of the token contract
    ///      but this could be different under certain applications
    function clearBlockList() external isBlockListOwner {
        _c++;
        emit BlockListCleared(msg.sender);
    }

    /*//////////////////////////////////////////////////////////////////////////
                          Public Read Functions
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice function to get blocklist status with True meaning that the operator is blocked
    function getBlockListStatus(address operator) public view returns (bool) {
        return _getBlockListStatus(operator);
    }

    /// @inheritdoc ERC165Upgradeable
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IBlockListRegistry).interfaceId || super.supportsInterface(interfaceId);
    }

    /*//////////////////////////////////////////////////////////////////////////
                          Public Write Functions
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice function to set the block list status for multiple operators
    /// @dev must be called by the blockList owner
    /// @dev the blockList owner is likely the same as the owner of the token contract
    ///      but this could be different under certain applications
    function setBlockListStatus(address[] calldata operators, bool status) external isBlockListOwner {
        for (uint256 i = 0; i < operators.length; i++) {
            _setBlockListStatus(operators[i], status);
        }
    }

    /*//////////////////////////////////////////////////////////////////////////
                            Internal Functions
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice internal function to get blockList status
    function _getBlockListStatus(address operator) internal view returns (bool) {
        return _blockList[_c][operator];
    }

    /// @notice internal function to set blockList status for one operator
    function _setBlockListStatus(address operator, bool status) internal {
        _blockList[_c][operator] = status;
        emit BlockListStatusChange(msg.sender, operator, status);
    }
}
