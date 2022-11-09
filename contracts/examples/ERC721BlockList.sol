// SPDX-License-Identifier: Apache-2.0

/// @title ERC721BlockList
/// @author transientlabs.xyz

pragma solidity 0.8.17;

import "OpenZeppelin/openzeppelin-contracts@4.7.3/contracts/token/ERC721/ERC721.sol";
import "OpenZeppelin/openzeppelin-contracts@4.7.3/contracts/access/Ownable.sol";
import "../BlockList.sol";

contract ERC721BlockList is ERC721, Ownable, BlockList {

    //================= State Variables =================//
    uint256 private _counter;

    //================= Constructor =================//
    constructor() ERC721("Test", "TST") Ownable() {}

    //================= Mint =================//
    function mint() external onlyOwner {
        _counter++;
        _mint(msg.sender, _counter);
    }

    //================= BlockList =================//
    function setBlockListStatus(address operator, bool status) external onlyOwner {
        _setBlockListStatus(operator, status);
    }

    //================= Overrides =================//
    function approve(address to, uint256 tokenId) public virtual override(ERC721) notBlocked(to) {
        ERC721.approve(to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public virtual override(ERC721) notBlocked(operator) {
        ERC721.setApprovalForAll(operator, approved);
    }
}