//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VoteSession is Ownable {
  event CandidateRegistered(uint256 _timestamp, address _address, string _name);

  struct Candidate {
    uint256 registered_at;
    address wallet_address;
    string name;
  }

  enum Status {
    CANDIDATE_REGISTER_OPEN,
    VOTING,
    FINISHED
  }

  Status public voteStatus;
  mapping(address => Candidate) public candidates;

  modifier isCandidateRegistrationOpen() {
    require(
      voteStatus == Status.CANDIDATE_REGISTER_OPEN,
      "Candidate registration has ended."
    );
    _;
  }

  constructor() {
    voteStatus = Status.CANDIDATE_REGISTER_OPEN;
  }

  function registerCandidate(address _address, string memory _name)
    external
    isCandidateRegistrationOpen
  {
    candidates[_address] = Candidate({
      name: _name,
      wallet_address: _address,
      registered_at: block.timestamp
    });

    emit CandidateRegistered(block.timestamp, _address, _name);
  }

  
}
