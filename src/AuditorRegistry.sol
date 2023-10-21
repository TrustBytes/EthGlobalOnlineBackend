// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
HOW TO USE

1. Create a table with createTable() // It can only be called once
2. Insert a profile with insertIntoTable(name, bio, competencies, bugsFound) //Also only once
3. Query your data with customQueryURL(filterName, comparison, value)
    - filterName is the value to filter like bugsFound (must be an integer for comparison)
    - Select comparison code // '0' for less than, '1' for equality, '2' for greater than
    - choose integer value to compare
    - It will return the full URL with the data requested
4. Update data by calling updateValueName(value)
*/

import "@tableland/evm/contracts/utils/TablelandDeployments.sol";
import "@tableland/evm/contracts/utils/SQLHelpers.sol";
import "@tableland/evm/contracts/utils/URITemplate.sol";
import "@tableland/evm/contracts/policies/Policies.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ZKPVerifier} from "@iden3/contracts/ZKPVerifier.sol";

interface ITablelandTable {
    function setBaseURI(string memory baseURI) external;
    /**
     * @dev See {ERC721AUpgradeable-_baseURI}.
     */
    function _baseURI() external view returns (string memory);
    
}

// interface ITablelandController {
    /**
     * @dev Object defining how a table can be accessed.
     */
    // struct Policy {
    //     bool allowInsert;
    //     bool allowUpdate;
    //     bool allowDelete;
    //     string whereClause;
    //     string withCheck;
    //     string[] updatableColumns;
    // }

    /**
     * @dev Returns a {Policy} struct defining how a table can be accessed by `caller`.
     */
    // function getPolicy(address caller) external payable returns (Policy memory);
// }

contract AuditorRegistry is ERC721Holder, ZKPVerifier { // TODO call setZKPRequest
    error AuditorExists();
    error TableExists();

    uint64 public constant TRANSFER_REQUEST_ID = 1;
    address private constant VALIDATOR_ADDRESS = 0xF2D4Eeb4d455fb673104902282Ce68B9ce4Ac450;
    uint256 private constant SCHEMA = 96201852078154344702923963389809399675;

    // error notOwner();
    uint256 private chainId;
    uint256 public tableId;
    uint256 public uniqueId;
    string private constant _TABLE_PREFIX = "trustbytes_auditors_list";
    string private uriTemplate;
    string private _baseURIString = "https://testnets.tableland.network/api/v1/query?unwrap=true&extract=";

    mapping (address => uint256) public auditorId;

    constructor() {
        chainId = block.chainid;
        owner = msg.sender;
        // uriTemplate = "SELECT+json_object%28%27id%27%2C+id%2C+%27address%27%2C+address%2C+%27name%27%2C+name%2C+%27bio%27%2C+bio%2C+%27competencies%27%2C+competencies%2C+%27bugsFound%27%2C+bugsFound%29+FROM+trustbytes_auditors_list_80001_{tableId}+WHERE+id%3D{id}";
    }

    function _afterProofSubmit(uint64 requestId, uint256[] memory inputs, ICircuitValidator validator) internal override {
        // zkproof was submitted
        // implement logic for writing to tableand
    }

    function queryByAddressURL(address auditorAddress) external view returns(string memory) {
        if (tableId == 0 || auditorId[auditorAddress] == 0) revert ();
        string memory queryStatement = "&statement=SELECT+json_object%28%27id%27%2C+id%2C+%27auditorId%27%2C+auditorId%2C+%27address%27%2C+address%2C+%27name%27%2C+name%2C+%27bio%27%2C+bio%2C+%27competencies%27%2C+competencies%2C+%27bugsFound%27%2C+bugsFound%29+FROM+";
        return string.concat(
            _baseURIString,
            "true", 
            queryStatement,
            _TABLE_PREFIX,
            "_", 
            Strings.toString(chainId),
            "_",
            Strings.toString(tableId),
            "+WHERE+auditorId%3D",
            Strings.toString(auditorId[auditorAddress])
        );
    }

    /**
    params filterName: Have to be the name of a column like id, auditorId, bugsFound
    params comparison: 0 for less than, 1 for equality, 2 for greater than
    params value: value you want to compare
    */
    function customQueryURL(string memory filterName, uint8 comparison, uint value) external view returns(string memory) {
        if (tableId == 0) revert ();
        string memory operator;
        if (comparison == 0) operator = "%3C"; // Less than
        if (comparison == 1) operator = "%3D"; // Equality
        if (comparison == 2) operator = "%3E"; // More than

        // string memory queryStatement = "&statement=SELECT+json_object%28%27id%27%2C+id%2C+%27auditorId%27%2C+auditorId%2C+%27address%27%2C+address%2C+%27name%27%2C+name%2C+%27bio%27%2C+bio%2C+%27competencies%27%2C+competencies%2C+%27bugsFound%27%2C+bugsFound%29+FROM+";
        return string.concat(
            _baseURIString,
            "false",
            "&statement=SELECT%20*%20FROM%20",
            _TABLE_PREFIX,
            "_",
            Strings.toString(chainId),
            "_",
            Strings.toString(tableId),
            "+WHERE+",
            filterName,
            operator,
            Strings.toString(value)
        );
    }

    function queryAllDataURL() external view returns(string memory) {
        return string.concat(
            _baseURIString,
            "false",
            "&statement=SELECT%20*%20FROM%20",
            _TABLE_PREFIX,
            "_",
            Strings.toString(chainId),
            "_",
            Strings.toString(tableId)
        );
    }

    function setURITemplate(string memory _uriTemplate)
        public
        onlyOwner
    {
        uriTemplate = _uriTemplate;
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseURIString = baseURI;
        TablelandDeployments.get().setBaseURI(baseURI);
    }

    function createTable() public {
        if (tableId != 0) revert TableExists();
        tableId = TablelandDeployments.get().create(
            address(this),
            SQLHelpers.toCreateFromSchema(
                "id integer primary key," // Notice the trailing comma
                "auditorId integer,"
                "bugsFound integer," // Separate lines for readability—but it's a single string
                "address text," 
                "name text,"
                "bio text," 
                "competencies text",
                _TABLE_PREFIX
            )
        );
    }

    // function updateController(address controller) public onlyOwner returns(address) {
    //     address currentController = TablelandDeployments.get().getController(tableId);
    //     if (currentController != address(this)) {
    //         TablelandDeployments.get().setController(address(this), tableId, controller);
    //     }
    //     return currentController;
    // }

    function insertIntoTable(string memory name, string memory bio, string memory competencies, string memory bugsFound) external {
        if (auditorId[msg.sender] != 0) revert AuditorExists();
        uniqueId++;
        auditorId[msg.sender] = uniqueId; 
        TablelandDeployments.get().mutate(
            address(this), // Table owner, i.e., this contract
            tableId,
            SQLHelpers.toInsert(
                _TABLE_PREFIX,
                tableId,
                "auditorId,bugsFound,address,name,bio,competencies",
                string.concat(
                    Strings.toString(auditorId[msg.sender]), // Insert the caller's address
                    ",",
                    bugsFound,
                    ",",
                    SQLHelpers.quote(Strings.toHexString(msg.sender)), // Insert the caller's address
                    ",",
                    SQLHelpers.quote(name), // Wrap strings in single quotes with the `quote` method
                    ",",
                    SQLHelpers.quote(bio),
                    ",",
                    SQLHelpers.quote(competencies)
                )
            )
        );
    }

    function updateBio(string memory bio) external {
        // Set the values to update
        string memory setters = string.concat("bio=", SQLHelpers.quote(bio));
        // Specify filters for which row to update
        string memory filters = string.concat("auditorId=", SQLHelpers.quote(Strings.toString(auditorId[msg.sender])));
        // Mutate a row at `address` with a new `val`—gating for the correct row is handled by the controller contract
        TablelandDeployments.get().mutate(
            address(this), tableId, SQLHelpers.toUpdate(_TABLE_PREFIX, tableId, setters, filters)
        );
    }

    function updateCompetencies(string memory competencies) external {
        // Set the values to update
        string memory setters = string.concat("competencies=", SQLHelpers.quote(competencies));
        // Specify filters for which row to update
        string memory filters = string.concat("auditorId=", SQLHelpers.quote(Strings.toString(auditorId[msg.sender])));
        // Mutate a row at `address` with a new `val`—gating for the correct row is handled by the controller contract
        TablelandDeployments.get().mutate(
            address(this), tableId, SQLHelpers.toUpdate(_TABLE_PREFIX, tableId, setters, filters)
        );
    }

    function updateBugsFound(uint32 bugs) external {
        // Set the values to update
        string memory setters = string.concat("bugsFound=", SQLHelpers.quote(Strings.toString(bugs)));
        // Specify filters for which row to update
        string memory filters = string.concat("auditorId=", SQLHelpers.quote(Strings.toString(auditorId[msg.sender])));
        // Mutate a row at `address` with a new `val`—gating for the correct row is handled by the controller contract
        TablelandDeployments.get().mutate(
            address(this), tableId, SQLHelpers.toUpdate(_TABLE_PREFIX, tableId, setters, filters)
        );
    }

    // function getPolicy(address sender)
    //     public
    //     payable
    //           override
    //     returns (
    //         ITablelandController.Policy memory
    //     )
    // {
    //     // if (sender == owner) {
    //         // return ITablelandController.Policy({
    //         //     allowInsert: true,
    //         //     allowUpdate: true,
    //         //     allowDelete: true,
    //         //     whereClause: "",
    //         //     withCheck: "",
    //         //     updatableColumns: new string[](0)
    //         // });
    //     // }

    //     // For all others, we'll let anyone insert but have controls on the update
    //     // First, establish WHERE clauses (i.e., where the address it the caller)
    //     string[] memory whereClause = new string[](1);
    //     whereClause[0] = string.concat("address=", SQLHelpers.quote(Strings.toHexString(sender)));

    //     // Restrict updates to a single `val` column
    //     string[] memory updatableColumns = new string[](1);
    //     updatableColumns[0] = "val";

    //     // Now, return the policy that gates by the WHERE clause & updatable columns
    //     // Note: insert calls won't need to check these additional parameters; they're just for the updates
    //     return ITablelandController.Policy({
    //         allowInsert: true,
    //         allowUpdate: true,
    //         allowDelete: false,
    //         whereClause: Policies.joinClauses(whereClause),
    //         withCheck: "",
    //         updatableColumns: updatableColumns
    //     });
    // }
}
