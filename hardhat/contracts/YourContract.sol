//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "hardhat/console.sol";


contract YourContract {
	// State Variables
	address public immutable owner;
	string public greeting = "Deployment successfull !!!";
	bool public premium = false;
	uint256 public totalCounter = 0;
	mapping(address => uint) public userGreetingCounter;

	event GreetingChange(
		address indexed greetingSetter,
		string newGreeting,
		bool premium,
		uint256 value
	);

	// Check packages/hardhat/deploy/00_deploy_your_contract.ts
	constructor(address _owner) {
		owner = _owner;
	}

	modifier isOwner() {
		require(msg.sender == owner, "Not the Owner");
		_;
	}

	function setGreeting(string memory _newGreeting) public payable {
		console.log(
			"Setting new greeting '%s' from %s",
			_newGreeting,
			msg.sender
		);

		greeting = _newGreeting;
		totalCounter += 1;
		userGreetingCounter[msg.sender] += 1;

		if (msg.value > 0) {
			premium = true;
		} else {
			premium = false;
		}

		emit GreetingChange(msg.sender, _newGreeting, msg.value > 0, msg.value);
	}

	
	function withdraw() public isOwner {
		(bool success, ) = owner.call{ value: address(this).balance }("");
		require(success, "Failed to send Ether");
	}

	
	receive() external payable {}
}
