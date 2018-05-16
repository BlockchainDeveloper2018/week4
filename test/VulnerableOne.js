'use strict';

import expectThrow from './helpers/expectThrow';

const VulnerableOne = artifacts.require('VulnerableOne.sol');

contract('VulnerableOneTest', function (accounts) {
    it('test construction', async function () {
        const contract = await VulnerableOne.new();
    });

    // it('test freeze', async function () {
    //     const token = await VulnerableOne.new({from: accounts[0]});
    //     await token.transfer(accounts[1], 1000, {from: accounts[0]});
    //     await token.freeze(1e10, {from: accounts[0]});
    //     await expectThrow(token.transfer(accounts[1], 1000, {from: accounts[0]}));
    // });
});