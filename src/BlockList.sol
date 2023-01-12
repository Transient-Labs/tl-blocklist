// SPDX-License-Identifier: Apache-2.0

/// @title BlockList
/// @notice abstract contract that can be inherited to block
///         approvals from non-royalty paying marketplaces
/// @author transientlabs.xyz

/**
    ____        _ __    __   ____  _ ________                     __ 
   / __ )__  __(_) /___/ /  / __ \(_) __/ __/__  ________  ____  / /_
  / __  / / / / / / __  /  / / / / / /_/ /_/ _ \/ ___/ _ \/ __ \/ __/
 / /_/ / /_/ / / / /_/ /  / /_/ / / __/ __/  __/ /  /  __/ / / / /_  
/_____/\__,_/_/_/\__,_/  /_____/_/_/ /_/  \___/_/   \___/_/ /_/\__/  
                                                                    
*/

pragma solidity 0.8.17;

///////////////////// CUSTOM ERRORS /////////////////////

/// @dev blocked operator error
error BlockedOperator();

///////////////////// BLOCKLIST CONTRACT /////////////////////

abstract contract BlockList {

    ///////////////////// STATE VARIABLES /////////////////////

    address public blockListRegistry;

    uint256 private _c; // variable that allows reset for `_blockList`
    address public blockListOwner;
    mapping(uint256 => mapping(address => bool)) private _blockList;

    //================= Events =================//
    event BlockListStatusChange(address indexed user, address indexed operator, bool indexed status);
    event BlockListCleared(address indexed user);
    event BlockListOwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    //================= Modifiers =================//
    /// @dev modifier to gate setter functions
    modifier isBlockListOwner {
        if (msg.sender != blockListOwner) {
            revert NotBlockListOwner();
        }
        _;
    }
    /// @dev modifier that can be applied to approval functions in order to block listings on marketplaces
    modifier notBlocked(address operator) {
        if (_getBlockListStatus(operator)) {
            revert IsBlockedOperator();
        }
        _;
    }

    //================= Constructor =================//
    constructor(address initBlockListOwner) {
        _setBlockListOwner(initBlockListOwner);
    }

    //================= Ownership Functions =================//
    /// @notice function to transfer ownership of the blockList
    /// @dev requires blockList owner
    /// @dev can be transferred to the ZERO_ADDRESS if desired
    /// @dev BE VERY CAREFUL USING THIS
    function transferBlockListOwnership(address newBlockListOwner) public isBlockListOwner {
        _setBlockListOwner(newBlockListOwner);
    }

    //================= View Function =================//
    /// @notice function to get blocklist status with True meaning that the operator is blocked
    function getBlockListStatus(address operator) public view returns (bool) {
        return _getBlockListStatus(operator);
    }

    //================= Setter Functions =================//
    /// @notice function to set the block list status for multiple operators
    /// @dev must be called by the blockList owner
    /// @dev the blockList owner is likely the same as the owner of the token contract 
    ///      but this could be different under certain applications
    function setBlockListStatus(address[] calldata operators, bool status) external isBlockListOwner {
        for (uint256 i = 0; i < operators.length; i++) {
            _setBlockListStatus(operators[i], status);
        }
    }

    /// @notice function to clear the block list status
    /// @dev must be called by the blockList owner
    /// @dev the blockList owner is likely the same as the owner of the token contract 
    ///      but this could be different under certain applications
    function clearBlockList() external isBlockListOwner {
        _c++;
        emit BlockListCleared(msg.sender);
    }

    //================= Helper Functions =================//
    /// @notice internal function to get blockList status
    function _getBlockListStatus(address operator) internal view returns (bool) {
        return _blockList[_c][operator];
    }

    /// @notice internal function to set blockList owner
    function _setBlockListOwner(address newOwner) internal {
        address oldOwner = blockListOwner;
        blockListOwner = newOwner;
        emit BlockListOwnershipTransferred(oldOwner, newOwner);
    }

    /// @notice internal function to set blockList status for one operator
    function _setBlockListStatus(address operator, bool status) internal {
        _blockList[_c][operator] = status;
        emit BlockListStatusChange(msg.sender, operator, status);
    }
}