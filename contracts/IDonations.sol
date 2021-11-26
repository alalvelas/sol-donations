// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IDonations {

    function createCampaign(
        uint256 _donationGoal,
        address payable _campaignAdmin,
        uint96 _deadline,
        string memory _name,
        string memory _description) external;

    function donate(uint256 _campaignId) external payable;

    function withdraw(uint256 _campaignId) external;

}