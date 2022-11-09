from brownie import ERC721BlockList, ERC1155BlockList, accounts, reverts
import pytest

@pytest.fixture()
def erc721():
    contract = ERC721BlockList.deploy({"from": accounts[0]})
    contract.mint({"from": accounts[0]})
    return contract

@pytest.fixture()
def erc1155():
    contract = ERC1155BlockList.deploy({"from": accounts[0]})
    contract.mint(100, {"from": accounts[0]})
    return contract

##################### View Function #####################
def test_getBlockListStatus_false(erc721, erc1155):
    assert not (erc721.getBlockListStatus(accounts[1]) and erc1155.getBlockListStatus(accounts[1]))

def test_getBlockListStatus_true(erc721, erc1155):
    erc721.setBlockListStatus(accounts[1], True, {"from": accounts[0]})
    erc1155.setBlockListStatus(accounts[1], True, {"from": accounts[0]})

    assert erc721.getBlockListStatus(accounts[1]) and erc1155.getBlockListStatus(accounts[1])


##################### ERC721 Approvals & Transfers #####################
def test_approve_not_on_block_list(erc721):
    erc721.approve(accounts[1], 1, {"from": accounts[0]})
    erc721.transferFrom(accounts[0].address, accounts[2].address, 1, {"from": accounts[1]})

def test_approve_on_block_list(erc721):
    erc721.setBlockListStatus(accounts[1], True, {"from": accounts[0]})
    with reverts("BlockList: operator is blocked"):
        erc721.approve(accounts[1], 1, {"from": accounts[0]})

    with reverts():
        erc721.transferFrom(accounts[0].address, accounts[2].address, 1, {"from": accounts[1]})

def test_approve_for_all_not_on_block_list(erc721):
    erc721.setApprovalForAll(accounts[1], True, {"from": accounts[0]})
    erc721.transferFrom(accounts[0].address, accounts[2].address, 1, {"from": accounts[1]})

def test_approval_for_all_on_block_list(erc721):
    erc721.setBlockListStatus(accounts[1], True, {"from": accounts[0]})
    with reverts("BlockList: operator is blocked"):
        erc721.setApprovalForAll(accounts[1], True, {"from": accounts[0]})

    with reverts():
        erc721.transferFrom(accounts[0].address, accounts[2].address, 1, {"from": accounts[1]})

##################### ERC1155 Approvals & Transfers #####################
def test_approve_for_all_not_on_block_list(erc1155):
    erc1155.setApprovalForAll(accounts[1], True, {"from": accounts[0]})
    erc1155.safeTransferFrom(accounts[0].address, accounts[2].address, 1, 50, "", {"from": accounts[1]})

def test_approval_for_all_on_block_list(erc1155):
    erc1155.setBlockListStatus(accounts[1], True, {"from": accounts[0]})
    with reverts("BlockList: operator is blocked"):
        erc1155.setApprovalForAll(accounts[1], True, {"from": accounts[0]})

    with reverts():
        erc1155.safeTransferFrom(accounts[0].address, accounts[2].address, 1, 50, "", {"from": accounts[1]})