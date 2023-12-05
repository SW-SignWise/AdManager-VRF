import { Signer } from "ethers";
import { ethers } from "hardhat";
import { expect } from "chai";
import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers"; // Import loadFixture correctly

describe("AdManager", () => {
  async function deployContract() {
    let subscriptionId: number = 800;
    const deployedAdManager = "0x83f6e1cf1dbf7bd90a85e6b85e5d4366fba08c28";
    const ownerAddress = "0xF160b254f173A677cb05E68b130BB37bE1B12b75";

    const Owner = await ethers.getImpersonatedSigner(ownerAddress);
    const Signer1 = ethers.Wallet.createRandom();

    const adManager = await ethers.getContractAt(
      "AdManager",
      deployedAdManager,
      Owner
    );

    return { adManager, Owner, Signer1, subscriptionId };
  }

  it("should set the correct s_subscriptionId, vrfCoordinator & s_owner during deployment", async () => {
    const { adManager, subscriptionId, Owner } = await loadFixture(
      deployContract
    );
    const slot0 = await ethers.provider.getStorage(
      adManager.getAddress(),
      "0x0"
    );
    const slot3 = await ethers.provider.getStorage(
      adManager.getAddress(),
      "0x3"
    );

    const vrfCoordinator = ethers.dataSlice(slot0, 12, 32); // 1 Diference between param 2 and 3. It´s equal to 64 Characters/Hexadecimals, Each 2 Hexadecimal is 1 byte.
    const subsId = ethers.dataSlice(slot0, 10, 12); // Assuming uint256 size is 32 bytes
    const s_owner = ethers.dataSlice(slot3, 2, 22); // Assuming uint256 size is 32 bytes

    expect(Number(subsId)).to.equal(subscriptionId);
    expect(vrfCoordinator).to.equal(
      "0x2ed832ba664535e5886b75d64c46eb9a228c2610"
    );
    expect(Owner.address.toUpperCase()).to.equal(s_owner.toUpperCase());
  });

  it("should request random words", async () => {
    const { adManager, Signer1 } = await loadFixture(deployContract);

    await expect(adManager.requestRandomWords()).not.to.be.rejected;
    await expect(adManager.connect(Signer1).requestRandomWords()).to.be
      .rejected;
  });

  it("should update amount of words by the owner", async () => {
    const { adManager, Signer1, Owner } = await loadFixture(deployContract);
    const newNumWords = 3;

    const slot3 = await ethers.provider.getStorage(
      adManager.getAddress(),
      "0x3"
    );

    const storageOld = ethers.dataSlice(slot3, 22, 26);

    expect(Number(storageOld)).to.equal(1);

    // Try to update by non-owner
    await expect(
      adManager.connect(Signer1).updateAmountWords(newNumWords.toString())
    ).to.be.rejected;

    // Update by owner
    await adManager.connect(Owner).updateAmountWords(newNumWords.toString());

    const slot3After = await ethers.provider.getStorage(
      adManager.getAddress(),
      "0x3"
    );
    const storageAfter = ethers.dataSlice(slot3After, 22, 26);

    expect(Number(storageAfter)).to.equal(newNumWords);
  });
});
