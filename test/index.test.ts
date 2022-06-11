import assert from "assert";

import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Contract } from "ethers";
import { ethers } from "hardhat";

const lootToMint = 100;

let lootPfpFactory: Contract;
let loot: Contract;

let deployer: SignerWithAddress;
let minter: SignerWithAddress;

beforeEach(async function() {

  [deployer, minter] = await ethers.getSigners();

  const Loot = await ethers.getContractFactory("Loot");
  loot = await Loot.deploy();

  for(let i = 1; i <= lootToMint; i++) {
    await loot.connect(minter).claim(i);
  }
  
  const LootPfpFactory = await ethers.getContractFactory("LootPFPFactory");
  lootPfpFactory = await LootPfpFactory.deploy(loot.address);
});

describe("Loot", function() {
  it("Deployed Successfully", function() {
    assert.ok(loot.address);
  });
  it("Minted Loot correctly", async function() {
    const minterBalance = await loot.balanceOf(minter.address);
    assert.equal(minterBalance, lootToMint);
  });
});

describe("LootPfpFactory", function () {
  it("Deployed successfully", function() {
    assert.ok(lootPfpFactory.address);
  });
});
