// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {Script} from 'forge-std/Script.sol';
import { AuditorRegistry, ICircuitValidator, ZKPVerifier } from "../src/AuditorRegistry.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployAuditorRegistry is Script {
    uint[] value;
    
constructor() {
    for (uint i; i < 64; i++) {
        value.push(0);
    }
}

    function run() public returns (AuditorRegistry ar) {
        uint256 deployerPrivateKey = vm.envUint('PRIVATE_KEY');
        vm.startBroadcast(deployerPrivateKey);
        ar = new AuditorRegistry();
        ar.createTable();
        ar.insertIntoTable("Marcelo", "Economist", "DAO", "10");
        ICircuitValidator validator = ICircuitValidator(0x3DcAe4c8d94359D31e4C89D7F2b944859408C618);
        ar.setZKPRequest(
            1,
            validator,
            94059560301743540431939984442851832139,
            15613733201444775213446901250862323859352022200538234341191763245966005767216,
            0,
            value
        );
        // ar._setZKPRequest(value);

        vm.stopBroadcast();
    }
}