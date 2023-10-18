// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { Test } from "forge-std/Test.sol";
import { AuditorRegistry } from "../src/AuditorRegistry.sol";
import { DeployAuditorRegistry } from "../script/DeployAuditorRegistry.s.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract TestAuditorRegistry is Test {
    AuditorRegistry internal ar;

    /// @dev A function invoked before each test case is run.
    function setUp() public virtual {
        ar = new DeployAuditorRegistry().run();
    }
}
