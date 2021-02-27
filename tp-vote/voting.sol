// SPDX-License-Identifier: MIT
pragma solidity 0.6.11;
pragma experimental ABIEncoderV2;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.0.0/contracts/access/Ownable.sol";

contract Voting is Ownable {

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    event VoterRegistered(address voterAddress);
    event ProposalsRegistrationStarted();
    event ProposalsRegistrationEnded();
    event ProposalRegistered(uint proposalId);
    event VotingSessionStarted();
    event VotingSessionEnded();
    event Voted (address voter, uint proposalId);
    event VotesTallied();
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);

    mapping(address => Voter) private _voters;
    Proposal[] public _proposals;

    WorkflowStatus private _status = WorkflowStatus.RegisteringVoters;
    uint private winningProposalId;

    modifier onlyRegisteredVoter() {
        require(_voters[msg.sender].isRegistered == true, "Voting: Voter not registered");
        _;
    }

    modifier hasStatus(WorkflowStatus requiredStatus) {
        require(_status == requiredStatus, "Voting: Cannot do this now");
        _;
    }

    function registerVoter(address _address) public onlyOwner hasStatus(WorkflowStatus.RegisteringVoters) {
        require(_address != address(0), "Voting: Cannot register a voter on zero address");
        require(_voters[_address].isRegistered == false, "Voting: Voter already registered");

        _voters[_address] = Voter(true, false, 0);
        emit VoterRegistered(_address);
    }

    function registerProposal(string memory description) public onlyRegisteredVoter hasStatus(WorkflowStatus.ProposalsRegistrationStarted) {
        require(bytes(description).length > 0, "Voting: Cannot register empty Proposal");

        _proposals.push(Proposal(description, 0));
        emit ProposalRegistered(_proposals.length - 1);
    }

    function getProposalsCount() public view returns(uint) {
        return _proposals.length;
    }

    function vote(uint _proposalId) public onlyRegisteredVoter hasStatus(WorkflowStatus.VotingSessionStarted) {
        require(_proposalId < _proposals.length, "Voting: Not a valid proposalId");
        require(_voters[msg.sender].hasVoted == false, "Voting: You have already voted");

        _voters[msg.sender].hasVoted = true;
        _voters[msg.sender].votedProposalId = _proposalId;
        _proposals[_proposalId].voteCount++;
        assert(_proposals[_proposalId].voteCount > 0);

        emit Voted(msg.sender, _proposalId);
    }

    function getVote(address _voter) public view returns(uint, string memory) {
        require(_voters[_voter].isRegistered == true, "Voting: voter not registered");
        require(_voters[_voter].hasVoted == true, "Voting: voter hasn't vote yet");

        return (_voters[_voter].votedProposalId, _proposals[_voters[_voter].votedProposalId].description);
    }

    function countVotes() public onlyOwner hasStatus(WorkflowStatus.VotingSessionEnded) {
        uint maxVoteCount = 0;
        for(uint i = 0; i < _proposals.length; i++) {
            if(_proposals[i].voteCount > maxVoteCount) {
                winningProposalId = i;
                maxVoteCount = _proposals[i].voteCount;
            }
        }
        assert(winningProposalId < _proposals.length);
        changeState(WorkflowStatus.VotesTallied);
        emit VotesTallied();
    }

    function getWinningProposal() public view hasStatus(WorkflowStatus.VotesTallied) returns(Proposal memory) {
        return _proposals[winningProposalId];
    }

    function changeState(WorkflowStatus _newStatus) internal {
        WorkflowStatus previousStatus = _status;
        _status = _newStatus;
        emit WorkflowStatusChange(previousStatus, _status);
    }
    function startProposalRegistration() public onlyOwner hasStatus(WorkflowStatus.RegisteringVoters) {
        changeState(WorkflowStatus.ProposalsRegistrationStarted);
    }
    function endProposalRegistration() public onlyOwner hasStatus(WorkflowStatus.ProposalsRegistrationStarted) {
        changeState(WorkflowStatus.ProposalsRegistrationEnded);
    }
    function startVotingSession() public onlyOwner hasStatus(WorkflowStatus.ProposalsRegistrationEnded) {
        changeState(WorkflowStatus.VotingSessionStarted);
    }
    function endVotingSession() public onlyOwner hasStatus(WorkflowStatus.VotingSessionStarted) {
        changeState(WorkflowStatus.VotingSessionEnded);
    }
}
