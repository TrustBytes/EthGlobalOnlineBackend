// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {Script} from "forge-std/Script.sol";
import {Verifier} from "../src/Verifier.sol";
import "@iden3/contracts/ZKPVerifier.sol";
import "@iden3/contracts/interfaces/ICircuitValidator.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployVerifier is Script {
    function run() public returns (Verifier vr) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        uint64 requestID = 1;
        ICircuitValidator validator = ICircuitValidator(
            0xF2D4Eeb4d455fb673104902282Ce68B9ce4Ac450
        );
        uint256 schemaID = 96201852078154344702923963389809399675;
        uint256 claimPathKey = 10001938008028566584545943360659591410749956066288022203008464723922949451249;
        uint256 operator = 1;
        uint256[] memory value = new uint256[](6);
        value[0] = uint256(0x0000001);
        value[1] = 0;
        value[2] = 0;
        value[3] = 0;
        value[4] = 0;
        value[5] = 0;
        vm.startBroadcast(deployerPrivateKey);
        vr = new Verifier();
        vr.setZKPRequest(
            requestID,
            validator,
            schemaID,
            claimPathKey,
            operator,
            value
        );

        vm.stopBroadcast();
    }
}
