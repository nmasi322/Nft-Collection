const { ethers } = require("hardhat");
require("dotenv").config({ path: ".env" });
const { WHITELIST_CONTRACT_ADDRESS, METADATA_URL } = require("../constants");

async function main(params) {
    const whitelistContract = WHITELIST_CONTRACT_ADDRESS;
    const metadataUrl = METADATA_URL;

    const jsDevsContract = await ethers.getContractFactory("JsDevs")

    const deployedContract = await jsDevsContract.deploy(metadataUrl, whitelistContract)

    console.log("JsDevs NFT Contract Address:", deployedContract.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });