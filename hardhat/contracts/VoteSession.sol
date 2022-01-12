//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title A voting session
/// @author Rares Stanciu
/// @notice You can use this contract to create a voting session,
///         register candidates and cast votes.
contract VoteSession is Ownable {
  /// @notice Event emitted when a new candidate is registered
  /// @param _timestamp Time when the candidate was registered
  /// @param _address The address of the candidate that has been registered
  /// @param _name The name of the candidate that has been registered
  event CandidateRegistered(uint256 _timestamp, address _address, string _name);

  /// @notice Event emitted when the voting is started
  /// @param _timestamp Time when the voting session has started
  event VotingStarted(uint256 _timestamp);

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
  uint256 public startDate;
  uint256 public duration;
  uint8 public numberOfCandidates;

  modifier isCandidateRegistrationOpen() {
    require(
      voteStatus == Status.CANDIDATE_REGISTER_OPEN,
      "Candidate registration has ended."
    );
    _;
  }

  modifier isVotingOpen() {
    require(voteStatus == Status.VOTING, "Voting is not open.");
    _;
  }

  constructor(uint256 _startDate, uint256 _duration) {
    voteStatus = Status.CANDIDATE_REGISTER_OPEN;
    startDate = _startDate;
    duration = _duration;
  }

  /// @notice Function called when registering a new candidate
  /// @dev Function will revert if voting has started/ended or if
  ///      the candidate is already registered.
  /// @param _address Candidate's address
  /// @param _name Candidate's name (will be shown in frontend)
  function registerCandidate(address _address, string memory _name)
    external
    isCandidateRegistrationOpen
  {
    require(
      candidates[_address].wallet_address == address(0),
      "Candidate already registered."
    );

    candidates[_address] = Candidate({
      name: _name,
      wallet_address: _address,
      registered_at: block.timestamp
    });

    numberOfCandidates++;

    emit CandidateRegistered(block.timestamp, _address, _name);
  }

  /// @notice Function called when starting the voting process
  /// @dev Function will revert if voting has already started/finished
  ///      or if there are not at least two candidates registered.
  function start() external isCandidateRegistrationOpen {
    require(block.timestamp >= startDate, "Voting cannot start yet.");
    require(numberOfCandidates > 1, "At least two candidates are necessary.");

    voteStatus = Status.VOTING;

    emit VotingStarted(block.timestamp);
  }
}
