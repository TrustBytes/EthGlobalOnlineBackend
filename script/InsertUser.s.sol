// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {AuditorRegistry} from "../src/AuditorRegistry.sol";

/// @dev Add a new user to the user table using your PK
contract InsertUser is Script {
    function run() public returns (AuditorRegistry ar) {
        uint256 PK = vm.envUint("PRIVATE_KEY");
        address addressRegistry = vm.envAddress("ADDRESS_REGISTRY");
        vm.startBroadcast(PK);
        ar = AuditorRegistry(addressRegistry);

        //@dev insert your custom data here
        ar.insertIntoTable("TB_USER", "Does trust bite?", "wallet,dao", "7");
        vm.stopBroadcast();
    }
}
