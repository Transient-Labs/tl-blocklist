// SPDX-License-Identifier: Apache-2.0

/// @title BlockList
/// @author transientlabs.xyz
/// @notice Version 2.0.0

/**
    ____        _ __    __   ____  _ ________                     __ 
   / __ )__  __(_) /___/ /  / __ \(_) __/ __/__  ________  ____  / /_
  / __  / / / / / / __  /  / / / / / /_/ /_/ _ \/ ___/ _ \/ __ \/ __/
 / /_/ / /_/ / / / /_/ /  / /_/ / / __/ __/  __/ /  /  __/ / / / /_  
/_____/\__,_/_/_/\__,_/  /_____/_/_/ /_/  \___/_/   \___/_/ /_/\__/  
                                                                     
  ______                      _            __     __          __        
 /_  __/________ _____  _____(_)__  ____  / /_   / /   ____ _/ /_  _____
  / / / ___/ __ `/ __ \/ ___/ / _ \/ __ \/ __/  / /   / __ `/ __ \/ ___/
 / / / /  / /_/ / / / (__  ) /  __/ / / / /_   / /___/ /_/ / /_/ (__  ) 
/_/ /_/   \__,_/_/ /_/____/_/\___/_/ /_/\__/  /_____/\__,_/_.___/____/  
                                                                        
*/

pragma solidity 0.8.17;

abstract contract BlockList {

    //================= Custom Errors =================//
    error NotBlockListOwner();
    error IsBlockedOperator();

    //================= State Variables =================//
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
    /// @notice function to set the block list status
    /// @dev must be called by the blockList owner
    /// @dev the blockList owner is likely the same as the owner of the token contract 
    ///      but this could be different under certain applications
    function setBlockListStatus(address operator, bool status) external isBlockListOwner {
        _blockList[_c][operator] = status;
        emit BlockListStatusChange(msg.sender, operator, status);
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
}