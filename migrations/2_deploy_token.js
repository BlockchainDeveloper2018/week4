'use strict';

const VulnerableOne = artifacts.require('VulnerableOne.sol');


module.exports = function(deployer, network) {
    deployer.deploy(VulnerableOne);
};
