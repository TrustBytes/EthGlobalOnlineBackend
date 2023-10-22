# Trustbytes Backend

## About The Project

This is the smart contract backend of Trustbytes, a project created for the ETHGlobalOnline hackathon.

### AuditorRegistry.sol

This contract contains the logic to write data to a tableland contract and verify PolygonID credentials.

## Getting Started

This a a quick guide on how to get working on the smart contracts locally.

### Prerequisites

- [Foundry](https://getfoundry.sh/)

### Installing and compiling

- installing external libraries
```bash
forge install
```

- compiling
```bash
forge build
```

## Usage

This is a list of the most frequently needed commands.

### Clean

Delete the build artifacts and cache directories:

```sh
$ forge clean
```

### Compile

Compile the contracts:

```sh
$ forge build
```

### Coverage

Get a test coverage report:

```sh
$ forge coverage
```

### Deploy

Deploy to Anvil:

```sh
$ anvil
$ forge script script/DeployAuditorRegistry.s.sol --broadcast --fork-url http://localhost:8545
```

### Format

Format the contracts:

```sh
$ forge fmt
```

### Gas Usage

Get a gas report:

```sh
$ forge test --gas-report
```

### Test

Run the tests:

```sh
$ forge test
```
