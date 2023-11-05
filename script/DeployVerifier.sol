// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {Verifier} from "../src/Verifier.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployVerifier is Script {
    function run() public returns (Verifier vr) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        ar = new Verifier();
        vm.stopBroadcast();
    }
}
