require("@nomiclabs/hardhat-waffle");
require("hardhat-deploy");
require("dotenv").config();

module.exports = {
  solidity: "0.8.4",
  networks: {
    hardhat: {
      chainID: 31337,
      blockConformations: 1,
    },
    goerli: {
      chainID: 5,
      blockConformations: 6,
      url: process.env.GOERLI_RPC_PROVIDER,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  namedAccounts: {
    deployer: {
      default: 0,
    },
    player: {
      default: 1,
    },
  },
};
