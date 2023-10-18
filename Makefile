-include .env

.PHONY: all test clean deploy help install snapshot format anvil

build:; forge build

all: clean remove install update build

deploytest: 
	forge script script/Deploy.s.sol:Deploy --rpc-url $(MUMBAI_RPC_URL) \
	--private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(API_KEY_POLYGONSCAN) -vvvv

tenderlyLogin:
	tenderly login --authentication-method access-key --access-key $(TENDERLY_API) --force
