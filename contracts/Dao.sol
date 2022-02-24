//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

interface NftMarketplace {
    function getPrice(address nftContract, uint nftId) external returns (uint price);
    function buy(address nftContract, uint nftId) external payable returns (bool success);
}

contract Dao {
    uint public proposalCount;
    mapping (address => Member) public members;
    mapping (uint => Proposal) public proposals;

    modifier isMember() {
        require(members[msg.sender].votingPower == 1);
        _;
    }

    struct Member {
        uint votingPower;
    }

    struct NFT {
        address contractAddress;
        uint nftId;
    }

    struct Proposal {
        uint id;
        address proposer;
        NFT nft;
        uint votingPeriod;
        uint forVotes;
    }

    function purchaseMembership() external payable {
        require(members[msg.sender].votingPower == 0, "");
        require(msg.value == 1 ether, "");
        members[msg.sender].votingPower = 1;
    }

    function propose(address nftContract,uint nftId) external isMember {
        proposalCount++;

        Proposal memory newProposal = Proposal({
            id: proposalCount,
            proposer: msg.sender,
            nft: NFT(nftContract, nftId),
            votingPeriod: (block.number + 1 weeks),
            forVotes: 0
        });

        proposals[newProposal.id] = newProposal;
    }

    function castVote(uint proposalId, uint8 v, bytes32 r, bytes32 s) public isMember {
        // require(_signatureVerify());

        Proposal storage proposal = proposals[proposalId];
        proposal.forVotes += members[msg.sender].votingPower;
    }

    function _signatureVerify() internal {
        // To Be Determined
    }

    function execute (uint proposalId) public {
        Proposal storage proposal = proposals[proposalId];
        // uint nftPrice = NftMarketplace().getPrice(proposal.nft.contractAddress, proposal.nft.nftId);
        // NftMarketplace().buy(proposal.nft.contractAdress, proposal.nft.nftId);
    }
}