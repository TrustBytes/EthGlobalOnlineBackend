// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {Script} from 'forge-std/Script.sol';
import { AuditorRegistry, ICircuitValidator, ZKPVerifier } from "../src/AuditorRegistry.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployAuditorRegistry is Script {
    uint[] value = [0, 0, 0, 0, 0, 0, 0];
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
            19935052448020978194678654852932611405,
            13265112789089156742742985212404101373286782412344084656487709967369040482137,
            0,
            value
        );
        // ar._setZKPRequest(value);

        vm.stopBroadcast();
    }
}