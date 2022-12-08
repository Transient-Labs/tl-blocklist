from brownie import ERC721BlockList, ERC1155BlockList, accounts, reverts, web3
import pytest

NOT_BLOCK_LIST_OWNER_ERROR = f"typed error: {web3.solidityKeccak(['string'], ['NotBlockListOwner()']).hex()[:10]}"
IS_BLOCKED_OPERATOR_ERROR = f"typed error: {web3.solidityKeccak(['string'], ['IsBlockedOperator()']).hex()[:10]}"

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

##################### Set Blocklist Access #####################
def test_setBlockListStatus_non_owner(erc721, erc1155):
    with reverts(NOT_BLOCK_LIST_OWNER_ERROR):
        erc721.setBlockListStatus(accounts[0].address, True, {"from": accounts[1]})
        erc1155.setBlockListStatus(accounts[0].address, True, {"from": accounts[1]})

##################### View Function #####################
def test_getBlockListStatus_false(erc721, erc1155):
    assert not (erc721.getBlockListStatus(accounts[1].address) and erc1155.getBlockListStatus(accounts[1].address))

def test_getBlockListStatus_true(erc721, erc1155):
    erc721.setBlockListStatus(accounts[1].address, True, {"from": accounts[0]})
    erc1155.setBlockListStatus(accounts[1].address, True, {"from": accounts[0]})

    assert erc721.getBlockListStatus(accounts[1].address) and erc1155.getBlockListStatus(accounts[1].address)


##################### Clear Blocklist #####################
def test_clearBlockList_non_owner(erc721, erc1155):
    erc721.setBlockListStatus(accounts[1].address, True, {"from": accounts[0]})
    erc1155.setBlockListStatus(accounts[1].address, True, {"from": accounts[0]})
    with reverts(NOT_BLOCK_LIST_OWNER_ERROR):
        erc721.clearBlockList({"from": accounts[1]})
        erc1155.clearBlockList({"from": accounts[1]})

def test_clearBlockList_owner(erc721, erc1155):
    erc721.setBlockListStatus(accounts[1].address, True, {"from": accounts[0]})
    erc1155.setBlockListStatus(accounts[1].address, True, {"from": accounts[0]})
    erc721.setBlockListStatus(accounts[2].address, True, {"from": accounts[0]})
    erc1155.setBlockListStatus(accounts[2].address, True, {"from": accounts[0]})

    erc721.clearBlockList({"from": accounts[0]})
    erc1155.clearBlockList({"from": accounts[0]})

    assert not (
        erc721.getBlockListStatus(accounts[1].address) and 
        erc721.getBlockListStatus(accounts[2].address) and
        erc1155.getBlockListStatus(accounts[1].address) and
        erc1155.getBlockListStatus(accounts[2].address)
    )

##################### ERC721 Approvals & Transfers #####################
def test_approve_not_on_block_list_721(erc721):
    erc721.approve(accounts[1], 1, {"from": accounts[0]})
    erc721.transferFrom(accounts[0].address, accounts[2].address, 1, {"from": accounts[1]})

def test_approve_on_block_list_721(erc721):
    erc721.setBlockListStatus(accounts[1], True, {"from": accounts[0]})
    with reverts(IS_BLOCKED_OPERATOR_ERROR):
        erc721.approve(accounts[1], 1, {"from": accounts[0]})

    with reverts():
        erc721.transferFrom(accounts[0].address, accounts[2].address, 1, {"from": accounts[1]})

def test_approveForAll_not_on_block_list_721(erc721):
    erc721.setApprovalForAll(accounts[1], True, {"from": accounts[0]})
    erc721.transferFrom(accounts[0].address, accounts[2].address, 1, {"from": accounts[1]})

def test_approveForAll_on_block_list_721(erc721):
    erc721.setBlockListStatus(accounts[1], True, {"from": accounts[0]})
    with reverts(IS_BLOCKED_OPERATOR_ERROR):
        erc721.setApprovalForAll(accounts[1], True, {"from": accounts[0]})

    with reverts():
        erc721.transferFrom(accounts[0].address, accounts[2].address, 1, {"from": accounts[1]})

##################### ERC1155 Approvals & Transfers #####################
def test_approveForAll_not_on_block_list_1155(erc1155):
    erc1155.setApprovalForAll(accounts[1], True, {"from": accounts[0]})
    erc1155.safeTransferFrom(accounts[0].address, accounts[2].address, 1, 50, "", {"from": accounts[1]})

def test_approveForAll_on_block_list_1155(erc1155):
    erc1155.setBlockListStatus(accounts[1], True, {"from": accounts[0]})
    with reverts(IS_BLOCKED_OPERATOR_ERROR):
        erc1155.setApprovalForAll(accounts[1], True, {"from": accounts[0]})

    with reverts():
        erc1155.safeTransferFrom(accounts[0].address, accounts[2].address, 1, 50, "", {"from": accounts[1]})