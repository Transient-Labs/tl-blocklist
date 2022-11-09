// SPDX-License-Identifier: Apache-2.0

/// @title ERC1155BlockList
/// @author transientlabs.xyz

pragma solidity 0.8.17;

import "OpenZeppelin/openzeppelin-contracts@4.7.3/contracts/token/ERC1155/ERC1155.sol";
import "OpenZeppelin/openzeppelin-contracts@4.7.3/contracts/access/Ownable.sol";
import "../BlockList.sol";

contract ERC1155BlockList is ERC1155, Ownable, BlockList {

    //================= State Variables =================//
    uint256 private _counter;

    //================= Constructor =================//
    constructor() ERC1155("") Ownable() {}

    //================= Mint =================//
    function mint(uint256 numToMint) external onlyOwner {
        _counter++;
        _mint(msg.sender, _counter, numToMint, "");
    }

    //================= BlockList =================//
    function setBlockListStatus(address operator, bool status) external onlyOwner {
        _setBlockListStatus(operator, status);
    }

    //================= Overrides =================//
    function setApprovalForAll(address operator, bool approved) public virtual override(ERC1155) notBlocked(operator) {
        ERC1155.setApprovalForAll(operator, approved);
    }
}