-include .env

.PHONY: all test clean deploy help install snapshot format anvil

build:; forge build

all: clean remove install update build

test:
	@forge test --fork-url $(MUMBAI_RPC_URL)

deploytest: 
	@forge script script/DeployAuditorRegistry.s.sol:DeployAuditorRegistry --rpc-url $(MUMBAI_RPC_URL) \
	--private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(API_KEY_POLYGONSCAN) -vvvv

tenderlyLogin:
	@tenderly login --authentication-method access-key --access-key $(TENDERLY_API) --force
