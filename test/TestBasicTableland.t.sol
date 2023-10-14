// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {BasicTableland} from "../src/BasicTableland.sol";

contract TestBasicTableland is Test {
    BasicTableland basicTableland;

    function setUp() external {
        basicTableland = new BasicTableland();
    }

    function testCreateTable() external {
        basicTableland.createAuditorsTable();
        uint256 tableId = basicTableland.tableId();

        assertTrue(tableId > 0);
    }

    modifier tableCreated() {
        basicTableland.createAuditorsTable();
        _;
    }

    function testAddAuditor() external tableCreated {
        address AUDITOR = makeAddr("auditor");

        vm.prank(AUDITOR);
        basicTableland.addAuditor("Auditor 1", 5);
    }
}
