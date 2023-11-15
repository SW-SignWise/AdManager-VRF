import { ethers } from "hardhat";
require("dotenv").config();

async function main() {
  const AdManager = await ethers.getContractFactory("AdManager");
  const adManager = await AdManager.deploy(
    Number(process.env.VRF_SUBSCRIPTION_ID)
  );

  console.log(`Ad Manager is deployed to: ${await adManager.getAddress()}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
