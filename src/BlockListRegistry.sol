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

/// @dev zero address error
error BlockedOperator();

///////////////////// BLOCKLIST CONTRACT /////////////////////