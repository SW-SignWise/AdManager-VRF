import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();

const config: HardhatUserConfig = {
  defaultNetwork: "PolygonTestnet",
  networks: {
    hardhat: {
      chainId: 80001,
      forking: {
        url: process.env.RPC_POLYGON_TESTNET!,
      },
      accounts: [
        {
          privateKey: process.env.PRIVATE_KEY!,
          balance: "10000000000000000000000",
        },
        {
          privateKey: process.env.PRIVATE_KEY2!,
          balance: "10000000000000000000000",
        },
      ],
    },
    PolygonTestnet: {
      url: process.env.RPC_POLYGON_TESTNET!,
      accounts: [process.env.PRIVATE_KEY!, process.env.PRIVATE_KEY2!],
    },
    PolygonMainet: {
      url: process.env.RPC_POLYGON_MAINNET!,
      accounts: [process.env.PRIVATE_KEY!, process.env.PRIVATE_KEY2!],
    },
  },
  solidity: {
    version: "0.8.23",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  mocha: {
    timeout: 40000,
  },
  etherscan: {
    apiKey: {
      polygonMumbai: process.env.SCAN_MUMBAI_API_KEY?.toString()!,
    },
  },
};

export default config;
