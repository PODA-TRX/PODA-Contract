var PODAContract = artifacts.require("./PODAContract.sol");

module.exports = function(deployer) {
  deployer.deploy(PODAContract);
};
