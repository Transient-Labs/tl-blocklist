# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# Clean the repo
clean:
	forge clean

# Remove modules
remove:
	rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

# Install the Modules
install:
	forge install foundry-rs/forge-std
	forge install OpenZeppelin/openzeppelin-contracts@v4.8.3
	forge install OpenZeppelin/openzeppelin-contracts-upgradeable@v4.8.3
	forge install Transient-Labs/tl-sol-tools@2.2.1

# Update modules
update: remove install

# Builds
build:
	forge fmt && forge clean && forge build

# Tests
tests:
	forge test --gas-report -vvv
