// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { Test } from "forge-std/Test.sol";
import { AuditorRegistry } from "../src/AuditorRegistry.sol";
import { DeployAuditorRegistry } from "../script/DeployAuditorRegistry.s.sol";
import { TablelandDeployments } from "@tableland/evm/contracts/utils/TablelandDeployments.sol";
import { ITablelandTables } from "@tableland/evm/contracts/interfaces/ITablelandTables.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract TestAuditorRegistry is Test {
    AuditorRegistry internal ar;
    address tablelandContract = address(TablelandDeployments.get());

    address USER = makeAddr("user");

    /// @dev A function invoked before each test case is run.
    function setUp() public virtual {
        ar = new DeployAuditorRegistry().run();
    }

    /**
     * .createTable()
     */
    function testCreateTable() external skipWhenNotForking {
        ar.createTable();

        assertTrue(ar.tableId() > 0);
    }

    modifier tableCreated() {
        ar.createTable();
        _;
    }

    function testCreateTableRevertsWhenAlreadyExists() external tableCreated skipWhenNotForking {
        vm.expectRevert(AuditorRegistry.TableExists.selector);
        ar.createTable();
    }

    /**
     * Add Auditor
     * .insertIntoTable()
     */
    function testInsertNewAuditor() external tableCreated skipWhenNotForking {
        vm.prank(USER);
        ar.insertIntoTable("auditor", "kick-ass auditor", "DeFi, ...", "42");

        ar.queryByAddressURL(USER);
    }

    modifier auditorAdded() {
        ar.createTable();
        vm.prank(USER);
        ar.insertIntoTable("auditor", "kick-ass auditor", "DeFi, ...", "42");
        _;
    }

    /**
     * Update functions
     * @dev just check if do not revert
     */
    function testUpdateFunctionsDoNotRevert() external auditorAdded skipWhenNotForking {
        vm.startPrank(USER);
        ar.updateBio("newBio");
        ar.updateCompetencies("newCompetencies");
        ar.updateBugsFound(42);
        vm.stopPrank();
    }

    /**
     * Public values
     * @dev just check if don't revert
     */
    function testGetFunctionsDoNotRevert() external tableCreated skipWhenNotForking {
        ar.tableId();
        ar.uniqueId();
        ar.owner();
        ar.auditorId(USER);
    }
}
