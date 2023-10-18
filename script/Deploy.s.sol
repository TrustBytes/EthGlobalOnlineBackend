// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { Tableland } from "../src/Tableland.sol";

// import { BaseScript } from "./Base.s.sol";
import {Script, console} from 'forge-std/Script.sol';

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is Script {
    function run() public returns (Tableland tableland) {
        uint256 deployerPrivateKey = vm.envUint('PRIVATE_KEY');
        vm.startBroadcast(deployerPrivateKey);
        Tableland tablelandContract = new Tableland();
        console.log(address(tablelandContract));
        tablelandContract.createTable();
        vm.stopBroadcast();
        return tablelandContract;
    }
}
