// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {TablelandDeployments} from "@tableland/contracts/utils/TablelandDeployments.sol";
import {ITablelandTables} from "@tableland/contracts/interfaces/ITablelandTables.sol";
import {SQLHelpers} from "@tableland/contracts/utils/SQLHelpers.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

contract BasicTableland is ERC721Holder {
    uint256 public tableId;
    string private constant TABLE_PREFIX = "auditors";
    // get address of tableland contract for this network
    ITablelandTables tablelandContract = ITablelandTables(TablelandDeployments.get());

    function createAuditorsTable() external {
        tableId = tablelandContract.create(
            address(this),
            SQLHelpers.toCreateFromSchema(
                "id integer primary key not null," // single string separated by commas
                "name text," // could be auditor's name
                "rating integer," // could be auditor's rating
                "address text", // could be auditor's address
                TABLE_PREFIX
            )
        );
    }

    function addAuditor(string memory name, uint8 rating) external {
        tablelandContract.mutate(
            address(this),
            tableId,
            SQLHelpers.toInsert(
                TABLE_PREFIX,
                tableId,
                "name,rating,address", // columns
                string(
                    abi.encodePacked(
                        SQLHelpers.quote(name), // quote for text values
                        ",", // comma separate values
                        // convert other values to string
                        Strings.toString(rating), // uint with .toString()
                        SQLHelpers.quote(Strings.toHexString(msg.sender)) // address or hexadecimal values with .toHexString()
                    )
                )
            )
        );
    }
}
