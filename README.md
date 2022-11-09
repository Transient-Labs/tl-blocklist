# Transient Labs BlockList
BlockList is a smart contract utility that can be utilized to block approvals of marketplaces that creators didn't want their work trading on

## 1. Problem Statement
It's a race to zero in terms of marketplace fees, but in an effort to keep cash flow, some marketplaces have decided forego creator feeds. This hurts creators an incredible amount and we believe that creators should have the option to block having their art listed on these platforms.

## 2. Our Solution
This is why we created BlockList. The `BlockList.sol` contract can be inherited by nft contracts and the modifier `notBlocked(address)` can be used on `setApprovalForAll` and `approve` functions in ERC-721 and/or ERC-1155 contracts. We have included a sample implementation of both in this repo.

Theoretically, this modifier could be applied to other functions, but we HIGHLY advise against this. Applying this logic to transfer functions introduces slight vulnerabilties that should be avoided. 

To implement the `BlockList.sol` contract, please make sure to add a function to the inheriting contract that can call the internal `_setBlockListStatus` function.

## License
This code is copyright Transient Labs, Inc 2022 and is licensed under the Apache-2.0 license. The name "BlockList" is also copyrighted by Transient Labs, Inc.