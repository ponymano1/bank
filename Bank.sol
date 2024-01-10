// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8;

contract Bank {
    mapping(address => uint256) private balances;
    address[3] private highValueAddresses;
    address onwer;


    constructor() {
        onwer = msg.sender;
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    
        uint minAmount = balances[msg.sender];
        uint minIndex = 1 << 255 - 1;
        for (uint i = 0; i < 3; i++) {
            if ( highValueAddresses[i] == msg.sender) {
                return;
            }

            if (balances[highValueAddresses[i]] < minAmount) {
                minIndex = i;
                minAmount = balances[highValueAddresses[i]];
            }
        }

        if (minIndex < 3) {
            highValueAddresses[minIndex] = msg.sender;
        }  

    }
    
    
    function withdraw() public {
        require(msg.sender == onwer, "NotOwner");
        uint256 amount = address(this).balance;
        payable(msg.sender).transfer(amount);
    }


    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    function getHighValueAddresses() public view returns (address[3] memory) {
        return highValueAddresses;
    }


}