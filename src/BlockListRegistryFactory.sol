// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import {Clones} from "lib/openzeppelin-contracts/contracts/proxy/Clones.sol";
import {BlockListRegistry} from "src/BlockListRegistry.sol";

/// @title BlockListFactory
/// @notice Contract factory to deploy blocklist registries.
/// @author transientlabs.xyz
/// @custom:version 4.0.0
contract BlockListRegistryFactory is Ownable {
    /*//////////////////////////////////////////////////////////////////////////
                                Events
    //////////////////////////////////////////////////////////////////////////*/

    event BlockListRegistryCreated(address indexed creator, address indexed template, address indexed registryAddress);

    /*//////////////////////////////////////////////////////////////////////////
                                  Public State Variables
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Address of the current blocklist registry template.
    address public blockListRegistryTemplate;

    /*//////////////////////////////////////////////////////////////////////////
                                Constructor
    //////////////////////////////////////////////////////////////////////////*/

    constructor(address initRegistryTemplate) Ownable() {
        blockListRegistryTemplate = initRegistryTemplate;
    }

    /*//////////////////////////////////////////////////////////////////////////
                            Admin Functions
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Update the address of the blocklist registry template used.
    /// @dev Must be contract owner to call.
    /// @param newBlockListRegistryTemplate Address of template to be used by clones.
    function setBlockListRegistryTemplate(address newBlockListRegistryTemplate) external onlyOwner {
        blockListRegistryTemplate = newBlockListRegistryTemplate;
    }

    /*//////////////////////////////////////////////////////////////////////////
                          Public Write Functions
    //////////////////////////////////////////////////////////////////////////*/

    /// @notice Creates a new blocklist registry with an initial list that can be added to later.
    /// @param initBlockList Initial list to active on the blocklist registry.
    /// @return address with the registry address
    function createBlockListRegistry(address[] calldata initBlockList) external returns (address) {
        address registry = Clones.clone(blockListRegistryTemplate);
        BlockListRegistry(registry).initialize(msg.sender, initBlockList);
        emit BlockListRegistryCreated(msg.sender, blockListRegistryTemplate, registry);
        return registry;
    }
}
