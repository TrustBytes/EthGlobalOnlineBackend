// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface AuditorsProfile {
    /**
     * PROFILE TABLE:
     * address: text | bio: text | competencies: !list figure this out
     */

    /**
     * @dev creates an entry in auditor's table
     * @dev mint a table?
     * FINDING / PORTFOLIO TABLE:
     * finding name | severity | category
     */
    function createProfile(string memory bio, string[] memory competencies) external;

    function editBio(string memory newBio) external;

    function editCompetencies(string[] memory competencies) external;
}
