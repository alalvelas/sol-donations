// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

import './DoNFT.sol';
import { IDonations } from './interfaces/IDonations.sol';

/// @title contract for making donation campaigns, where donations are accepted in Ether
contract Donations is IDonations, Ownable, ReentrancyGuard, DoNFT {
	using Counters for Counters.Counter;

	struct Campaign {
		uint256 donationGoal;
		address payable admin;
		uint96 deadline;
		bool active;
		string name;
		string description;
	}

	Counters.Counter campaignCount;
	mapping(uint256 => Campaign) idToCampaign;
	mapping(uint256 => uint256) campaignIdToAmount;
	/// @dev used to keep track of donors.
	///      First-time donors receive a NTF as a reward
	mapping(address => bool) hasDonated;

	event CampaignCreated(string _name, uint256 _id);
	event GoalReached(uint256 _id);
	event DeadlinePassed(uint256 _id);

	/// @dev campaign is active if it's goal is not reached or if deadline has not passed
	modifier campaignActive(uint256 _id) {
		Campaign storage campaign = idToCampaign[_id];
		require(campaign.active, 'Campaign must be active in order to donate');
		_;
	}

	/// @inheritdoc IDonations
	function createCampaign(
		uint256 _donationGoal,
		address payable _campaignAdmin,
		uint96 _deadline,
		string memory _name,
		string memory _description
	) public override onlyOwner {
		campaignCount.increment();
		uint256 id = campaignCount.current();
		idToCampaign[id] = Campaign(
			_donationGoal,
			_campaignAdmin,
			_deadline,
			true,
			_name,
			_description
		);
		emit CampaignCreated(_name, id);
	}

	/// @inheritdoc IDonations
	function donate(uint256 _campaignId)
		public
		payable
		override
		campaignActive(_campaignId)
	{
		Campaign storage campaign = idToCampaign[_campaignId];
		campaignIdToAmount[_campaignId] += msg.value;
		if (!hasDonated[msg.sender]) {
			mintDoNFT(msg.sender);
		}
		hasDonated[msg.sender] = true;
		if (campaignIdToAmount[_campaignId] >= campaign.donationGoal) {
			campaign.active = false;
			emit GoalReached(_campaignId);
		}
		if (uint256(campaign.deadline) <= block.timestamp) {
			campaign.active = false;
			emit DeadlinePassed(_campaignId);
		}
	}

	/// @inheritdoc IDonations
	function withdraw(uint256 _campaignId) public override nonReentrant {
		require(msg.sender == idToCampaign[_campaignId].admin, 'Not allowed');
		uint256 toWithdraw = campaignIdToAmount[_campaignId];
		campaignIdToAmount[_campaignId] = 0;
		(bool success, ) = msg.sender.call{ value: toWithdraw }('');
		require(success, 'Sending funds failed');
	}

	function getCampaign(uint256 _id)
		public
		view
		returns (
			string memory name,
			uint256 amount,
			uint256 deadline,
			uint256 donationGoal
		)
	{
		Campaign storage campaign = idToCampaign[_id];
		return (
			campaign.name,
			campaignIdToAmount[_id],
			campaign.deadline,
			campaign.donationGoal
		);
	}
}
