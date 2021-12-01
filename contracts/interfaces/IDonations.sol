// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IDonations {

    /**
     * Creates new campaign
     *
     * @param _donationGoal - Amount in native coin to be reached
     * @param _campaignAdmin - Admin of the campaign
     * @param _deadline - UNIX timestamp after donationing isn't available
     * @param _name - Campaign name
     * @param _description - Campaign description
     *
     * No return, reverts on error
     */
    function createCampaign(
        uint256 _donationGoal,
        address payable _campaignAdmin,
        uint96 _deadline,
        string memory _name,
        string memory _description) external;

    /**
     * Donates funds to the specific campaign
     * @notice payable
     *
     * @param _campaignId - Id of the campaign
     *
     * No return, reverts on error
     */
    function donate(uint256 _campaignId) external payable;

    /**
     * Withdraws funds from the specific campaign
     * @notice Only campaign admin can call
     *
     * @param _campaignId - Id of the campaign
     *
     * No return, reverts on error
     */
    function withdraw(uint256 _campaignId) external;

}