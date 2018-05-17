'use strict';

import {assertEquals} from './helpers/asserts';

const VulnerableOne = artifacts.require('VulnerableOne.sol');

contract('VulnerableOneTest', function (accounts) {
    it('test init', async function () {
        const contract = await VulnerableOne.new();
    });

    it('create superuser and user and check permissions', async function () {
        const super_user = await VulnerableOne.new();
        assertEquals(await super_user.is_i_super_user(), true);
        super_user.add_new_user('0x0000001');
        assertEquals(await super_user.is_user_super_user('0x0000001'), false);
    });

    it('add and remove users', async function () {
        const super_user = await VulnerableOne.new();
        super_user.add_new_user('0x00000001');
        super_user.add_new_user('0x00000002');
        super_user.add_new_user('0x00000003');
        super_user.add_new_user('0x00000004');
        super_user.add_new_user('0x00000005');

        await super_user.remove_user('0x00000003');
    });
});