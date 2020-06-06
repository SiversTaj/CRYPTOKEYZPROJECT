const Demo = artifacts.require("Demo");

const CryptoKeyz = artifacts.require("CryptoKeyz");

module.exports = function(deployer) {
    //deploy  demo and a name
  deployer.deploy(Demo);
  deployer.deploy(CryptoKeyz);
};
