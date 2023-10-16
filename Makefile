-include .env

.PHONY: all test clean deploy help install snapshot format anvil

build:; forge build

all: clean remove install update build

deploytest: 
	forge script script/DeployDatabase.s.sol:DeployDatabase --rpc-url $(MUMBAI_RPC_URL) \
	--private-key $(ETH_FROM) --broadcast --verify --etherscan-api-key $(API_KEY_POLYGONSCAN) -vvvv

tenderlyLogin:
	tenderly login --authentication-method access-key --access-key $(TENDERLY_API) --force
