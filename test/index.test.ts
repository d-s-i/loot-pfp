import assert from "assert";

import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Contract } from "ethers";
import { ethers } from "hardhat";

let lootPfpFactory: Contract;
let loot: Contract;

let deployer: SignerWithAddress;
let minter: SignerWithAddress;

beforeEach(async function() {

  [deployer, minter] = await ethers.getSigners();

  const Loot = await ethers.getContractFactory("Loot");
  loot = await Loot.deploy();

  for(let i = 1; i < 7777; i++) {
    await loot.connect(minter).claim(i);
  }
  
  const LootPfpFactory = await ethers.getContractFactory("LootPFPFactory");
  lootPfpFactory = await LootPfpFactory.deploy(loot.address);
});

describe("LootPfpFactory", function () {
  it("Deployed successfully", function() {
    assert.ok(lootPfpFactory.address);
  });
});
