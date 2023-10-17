// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@tableland/evm/contracts/utils/TablelandDeployments.sol";
import "@tableland/evm/contracts/utils/SQLHelpers.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@tableland/evm/contracts/policies/Policies.sol";

interface ITablelandController {
    /**
     * @dev Object defining how a table can be accessed.
     */
    struct Policy {
        bool allowInsert;
        bool allowUpdate;
        bool allowDelete;
        string whereClause;
        string withCheck;
        string[] updatableColumns;
    }

    /**
     * @dev Returns a {Policy} struct defining how a table can be accessed by `caller`.
     */
    function getPolicy(address caller) external payable returns (Policy memory);
}

contract Tableland is ERC721Holder {
    // error notOwner();

    uint256 public tableId;
    string private constant _TABLE_PREFIX = "my_quickstart_table";
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert();
        _;
    }

    function createTable() public {
        tableId = TablelandDeployments.get().create(
            address(this),
            SQLHelpers.toCreateFromSchema(
                "id integer primary key," // Notice the trailing comma
                "address text," "val text", // Separate lines for readability—but it's a single string
                _TABLE_PREFIX
            )
        );
    }

    function updateController(address controller) public onlyOwner {
        address currentController = TablelandDeployments.get().getController(tableId);
        if (currentController != address(this)) {
            TablelandDeployments.get().setController(address(this), tableId, controller);
        }
    }

    function insertIntoTable(string memory name, string memory bio, string memory competencies, uint bugsFound) external {
        TablelandDeployments.get().mutate(
            address(this), // Table owner, i.e., this contract
            tableId,
            SQLHelpers.toInsert(
                _TABLE_PREFIX,
                tableId,
                "address,name,bio,competencies,bugsFound",
                string.concat(
                    SQLHelpers.quote(Strings.toHexString(msg.sender)), // Insert the caller's address
                    ",",
                    SQLHelpers.quote(name), // Wrap strings in single quotes with the `quote` method
                    ",",
                    SQLHelpers.quote(bio),
                    ",",
                    SQLHelpers.quote(competencies),
                    ",",
                    SQLHelpers.quote(Strings.toString(bugsFound))
                )
            )
        );
    }

    // Update only the row that the caller inserted
    function updateTable(string memory bio) external {
        // Set the values to update
        string memory setters = string.concat("bio=", SQLHelpers.quote(bio));
        // Specify filters for which row to update
        string memory filters = string.concat("address=", SQLHelpers.quote(Strings.toHexString(msg.sender)));
        // Mutate a row at `address` with a new `val`—gating for the correct row is handled by the controller contract
        TablelandDeployments.get().mutate(
            address(this), tableId, SQLHelpers.toUpdate(_TABLE_PREFIX, tableId, setters, filters)
        );
    }

    function getPolicy(address sender)
        public
        payable
            //   override
        returns (
            ITablelandController.Policy memory
        )
    {
        // if (sender == owner) {
            // return ITablelandController.Policy({
            //     allowInsert: true,
            //     allowUpdate: true,
            //     allowDelete: true,
            //     whereClause: "",
            //     withCheck: "",
            //     updatableColumns: new string[](0)
            // });
        // }

        // For all others, we'll let anyone insert but have controls on the update
        // First, establish WHERE clauses (i.e., where the address it the caller)
        string[] memory whereClause = new string[](1);
        whereClause[0] = string.concat("address=", SQLHelpers.quote(Strings.toHexString(sender)));

        // Restrict updates to a single `val` column
        string[] memory updatableColumns = new string[](1);
        updatableColumns[0] = "val";

        // Now, return the policy that gates by the WHERE clause & updatable columns
        // Note: insert calls won't need to check these additional parameters; they're just for the updates
        return ITablelandController.Policy({
            allowInsert: true,
            allowUpdate: true,
            allowDelete: false,
            whereClause: Policies.joinClauses(whereClause),
            withCheck: "",
            updatableColumns: updatableColumns
        });
    }
}
