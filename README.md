# Transient Labs BlockList
BlockList is a smart contract utility that can be utilized to block approvals of marketplaces that creators don't want their work trading on.

## 1. Problem Statement
It's a race to zero in terms of marketplace fees, but in an effort to keep cash flow, some marketplaces have decided forego creator feeds. This hurts creators an incredible amount and we believe that creators should have the option to block having their art listed on these platforms.

## 2. Our Solution
This is why we created BlockList. The `BlockList.sol` contract can be inherited by nft contracts and the modifier `notBlocked(address)` can be used on `setApprovalForAll` and `approve` functions in ERC-721 and/or ERC-1155 contracts. We have included a sample implementation of both in this repo.

Theoretically, this modifier could be applied to other functions, but we HIGHLY advise against this. Applying this logic to transfer functions introduces slight vulnerabilties that should be avoided. 

To implement BlockList, simply inherit `BlockList.sol`.

## 3. Why Not An Allowlist Method Instead?
To keep composability with new standards and reduced interaction needed in the future, BlockList is implemented as a blocker rather than an allower. We welcome feedback on this.

## Deployments

### Mainnet
| Contract                                     | Version | Address                                    |
| -------------------------------------------- | ------- | ------------------------------------------ |
| BlockListRegistry                            | 3.2.0   | 0xa31DCBe2dF53bd70CaB02e25eDca1cB1a771890A |
| BlockListRegistryFactory                     | 3.2.0   | 0xf1d8C4acb1B983f231AC60DF57692dB9747a7133 |
| OpenSea Compliant BlockList Registry         |         | 0x56Fe4de01B15BB2AFA969f914692867acaC27ba5 |
| Blur Compliant BlockList Registry            |         | 0x3b60fB5Dfa39D7641558Cd62c96805457eb8f952 |

### Goerli
| Contract                              | Version | Address                                    |
| ------------------------------------- | ------- | ------------------------------------------ |
| BlockListRegistry                     | 3.2.0   | 0xB45881316D7Aa9F3f14344eF7c94897b687f5641 |
| BlockListRegistryFactory              | 3.2.0   | 0xf2E232dA9F4300A06B763dD558AA358fe8DfE8b7 |
| TL Test BlockList Registry            |         | 0x0d656e3ECFA3D9a9B9792ff33F09Ff5f55cB8316 |

## Disclaimer
We have verified with OpenSea engineers that BlockList is fully compatible with their royalties enforcement system, as of 11/7/2022.

This codebase is provided on an "as is" and "as available" basis.

We do not give any warranties and will not be liable for any loss incurred through any use of this codebase.

## License
This code is copyright Transient Labs, Inc 2022 and is licensed under the MIT license.