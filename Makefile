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
	forge install foundry-rs/forge-std --no-commit
	forge install Transient-Labs/tl-sol-tools@3.1.0 --no-commit

# Update the modules
update: remove install

# Builds
clean:
	forge fmt && forge clean

build:
	forge build --evm-version paris

clean_build: clean bulid

# Tests
quick_test:
	forge test --fuzz-runs 256

std_test:
	forge test

gas_test:
	forge test --gas-report

fuzz_test:
	forge test --fuzz-runs 10000

# Deploy BlockListRegistry
deploy_BlockListRegistry_sepolia: build
	forge script script/Deploy.s.sol:DeployBlockListRegistry --evm-version paris --rpc-url sepolia --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockListRegistry.sol:BlockListRegistry --chain sepolia --watch --constructor-args ${CONSTRUCTOR_ARGS}
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀

deploy_BlockListRegistry_arb_sepolia: build
	forge script script/Deploy.s.sol:DeployBlockListRegistry --evm-version paris --rpc-url arbitrum_sepolia --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockListRegistry.sol:BlockListRegistry --chain arbitrum-sepolia --watch --constructor-args ${CONSTRUCTOR_ARGS}
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀

deploy_BlockListRegistry_base_sepolia: build
	forge script script/Deploy.s.sol:DeployBlockListRegistry --evm-version paris --rpc-url base_sepolia --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockListRegistry.sol:BlockListRegistry --chain base-sepolia --watch --constructor-args ${CONSTRUCTOR_ARGS}
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀

deploy_BlockListRegistry_mainnet: build
	forge script script/Deploy.s.sol:DeployBlockListRegistry --evm-version paris --rpc-url mainnet --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockListRegistry.sol:BlockListRegistry --chain mainnet --watch --constructor-args ${CONSTRUCTOR_ARGS}
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀

deploy_BlockListRegistry_arbitrum_one: build
	forge script script/Deploy.s.sol:DeployBlockListRegistry --evm-version paris --rpc-url arbitrum --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockListRegistry.sol:BlockListRegistry --chain arbitrum --watch --constructor-args ${CONSTRUCTOR_ARGS}
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀

deploy_BlockListRegistry_base: build
	forge script script/Deploy.s.sol:DeployBlockListRegistry --evm-version paris --rpc-url base --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockListRegistry.sol:BlockListRegistry --chain base --watch --constructor-args ${CONSTRUCTOR_ARGS}
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀

# Deploy BlockAllRegistry
deploy_BlockAllRegistry_sepolia: build
	forge script script/Deploy.s.sol:DeployBlockAllRegistry --evm-version paris --rpc-url sepolia --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockAllRegistry.sol:BlockAllRegistry --chain sepolia --watch
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀

deploy_BlockAllRegistry_arb_sepolia: build
	forge script script/Deploy.s.sol:DeployBlockAllRegistry --evm-version paris --rpc-url arb_sepolia --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockAllRegistry.sol:BlockAllRegistry --chain arbitrum-sepolia --watch
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀

deploy_BlockAllRegistry_base_sepolia: build
	forge script script/Deploy.s.sol:DeployBlockAllRegistry --evm-version paris --rpc-url base_sepolia --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockAllRegistry.sol:BlockAllRegistry --chain base-sepolia --watch
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀

deploy_BlockAllRegistry_mainnet: build
	forge script script/Deploy.s.sol:DeployBlockAllRegistry --evm-version paris --rpc-url mainnet --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockAllRegistry.sol:BlockAllRegistry --chain mainnet --watch
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀

deploy_BlockAllRegistry_arbitrum_one: build
	forge script script/Deploy.s.sol:DeployBlockAllRegistry --evm-version paris --rpc-url arbitrum --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockAllRegistry.sol:BlockAllRegistry --chain arbitrum --watch
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀

deploy_BlockAllRegistry_basea: build
	forge script script/Deploy.s.sol:DeployBlockAllRegistry --evm-version paris --rpc-url base --ledger --sender ${SENDER} --broadcast
	sleep 3
	$(eval deployed_contract=$(shell cat out.txt))
	forge verify-contract $(deployed_contract) src/BlockAllRegistry.sol:BlockAllRegistry --chain base --watch
	rm out.txt
	@echo 🚀🚀🚀 CONTRACT DEPLOYED TO $(deployed_contract) 🚀🚀🚀
