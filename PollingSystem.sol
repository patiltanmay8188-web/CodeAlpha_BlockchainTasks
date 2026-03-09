// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PollingSystem {

    struct Poll {
        string title;
        string[] options;
        uint endTime;
        mapping(uint => uint) voteCount;
        mapping(address => bool) voted;
    }

    Poll public poll;

    function createPoll(string memory _title, string[] memory _options, uint duration) public {
        poll.title = _title;
        poll.options = _options;
        poll.endTime = block.timestamp + duration;
    }

    function vote(uint option) public {
        require(block.timestamp < poll.endTime, "Voting ended");
        require(!poll.voted[msg.sender], "Already voted");

        poll.voteCount[option]++;
        poll.voted[msg.sender] = true;
    }

    function getWinner() public view returns(string memory winner) {
        require(block.timestamp >= poll.endTime, "Poll still active");

        uint winningVoteCount = 0;
        uint winningOption = 0;

        for(uint i = 0; i < poll.options.length; i++){
            if(poll.voteCount[i] > winningVoteCount){
                winningVoteCount = poll.voteCount[i];
                winningOption = i;
            }
        }

        winner = poll.options[winningOption];
    }
}
