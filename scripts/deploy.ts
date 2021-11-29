import { ethers } from "hardhat";

async function main() {
  const [deployer] = await ethers.getSigners();
  if (deployer === undefined) throw new Error("Deployer is undefined.");
  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Donations = await ethers.getContractFactory("Donations");
  const donations = await Donations.deploy();

  console.log("Donations address:", donations.address);
}

main()
  // eslint-disable-next-line no-process-exit
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    // eslint-disable-next-line no-process-exit
    process.exit(1);
  });
