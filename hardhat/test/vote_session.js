const { expect } = require("chai");
const { ethers, network } = require("hardhat");

describe("Vote session", function () {
  let contract;
  let owner;

  beforeEach(async () => {
    [owner] = await ethers.getSigners();

    // Deploy VoteSession contract
    const VoteSession = await ethers.getContractFactory("VoteSession");
    contract = await VoteSession.deploy();
    await contract.deployed();
  });

  it("should initialize", async () => {
    expect(contract).to.be.ok;

    // Check that the vote session starts in the CANDIDATE_REGISTRATION_OPEN state
    expect(await contract.voteStatus()).to.equal(0); // Status.CANDIDATE_REGISTRATION_OPEN == 0
  });

  it("should set ownership correctly", async () => {
    // Fetch contract owner
    expect(await contract.owner()).to.be.equal(owner.address);
  });

  it("should allow candidate registration after creation", async function () {
    // Register candidate
    await network.provider.send("evm_setNextBlockTimestamp", [2209969083]);
    const tx = await contract.registerCandidate(
      owner.address,
      "Contract owner"
    );
    await tx.wait();

    // Check that the candidate has been registered successfully
    const candidate = await contract.candidates(owner.address);
    expect(candidate.name).to.be.equal("Contract owner");
    expect(candidate.wallet_address).to.be.equal(owner.address);
    expect(candidate.registered_at).to.be.equal(2209969083);
  });
});
