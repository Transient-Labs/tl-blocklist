// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import {ERC165Upgradeable} from "openzeppelin-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import {OwnableAccessControlUpgradeable} from "tl-sol-tools/upgradeable/access/OwnableAccessControlUpgradeable.sol";
import {IBlockListRegistry} from "src/IBlockListRegistry.sol";

/// @title BlockListRegistry
/// @notice Registry that can be used to block approvals from non-royalty paying marketplaces
/// @author transientlabs.xyz
/// @custom:version 4.1.0
contract BlockListRegistry is IBlockListRegistry, OwnableAccessControlUpgradeable, ERC165Upgradeable {
    /*//////////////////////////////////////////////////////////////////////////
                                    Constants
    //////////////////////////////////////////////////////////////////////////*/

    bytes32 public constant BLOCK_LIST_ADMIN_ROLE = keccak256("BLOCK_LIST_ADMIN_ROLE");

    /*//////////////////////////////////////////////////////////////////////////
                               Private State Variables
    //////////////////////////////////////////////////////////////////////////*/

    uint256 private _c; // variable that allows reset for `_blockList`
    mapping(uint256 => mapping(address => bool)) private _blockList;

    /*//////////////////////////////////////////////////////////////////////////
                                Constructor
    //////////////////////////////////////////////////////////////////////////*/

    /// @param disable Disable the initalizer on deployment
    constructor(bool disable) {
        if (disable) _disableInitializers();
    }

    /// @notice Function that can be called once to initialize the registry
    /// @param newOwner The initial owner of this contract
    /// @param initBlockList Initial list of addresses to add to the blocklist
    function initialize(address newOwner, address[] memory initBlockList) external initializer {
        uint256 len = initBlockList.length;
        for (uint8 i = 0; i < len; i++) {
            _setBlockListStatus(initBlockList[i], true);
        }
        __OwnableAccessControl_init(newOwner);
    }

    /*//////////////////////////////////////////////////////////////////////////
                            Admin Functions
    //////////////////////////////////////////////////////////////////////////*/

    /// @inheritdoc IBlockListRegistry
    /// @dev Must be called by the blockList owner or blocklist admin
    function clearBlockList() external onlyRoleOrOwner(BLOCK_LIST_ADMIN_ROLE) {
        _c++;
        emit BlockListCleared(msg.sender);
    }

    /*//////////////////////////////////////////////////////////////////////////
                          Public Read Functions
    //////////////////////////////////////////////////////////////////////////*/

    /// @inheritdoc IBlockListRegistry
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

    /// @inheritdoc IBlockListRegistry
    function setBlockListStatus(address[] calldata operators, bool status)
        external
        onlyRoleOrOwner(BLOCK_LIST_ADMIN_ROLE)
    {
        for (uint256 i = 0; i < operators.length; i++) {
            _setBlockListStatus(operators[i], status);
        }
    }

    /*//////////////////////////////////////////////////////////////////////////
                            Internal Functions
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Internal function to get blockList status
    /// @param operator The address for which to get the BlockList status
    function _getBlockListStatus(address operator) internal view returns (bool) {
        return _blockList[_c][operator];
    }

    /// @notice Internal function to set blockList status for one operator
    /// @param operator Address to set the status for
    /// @param status True means add to the BlockList
    function _setBlockListStatus(address operator, bool status) internal {
        _blockList[_c][operator] = status;
        emit BlockListStatusChange(msg.sender, operator, status);
    }
}
