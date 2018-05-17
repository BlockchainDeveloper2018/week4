pragma solidity ^0.4.23;

import "zeppelin-solidity/contracts/math/SafeMath.sol";

/*
TZ: contract creator becomes the first superuser. Then he adds new users and superusers. Every superuser can add new users and superusers;
If user sends ether, his balance is increased. Then he can withdraw eteher from his balance;
*/


contract VulnerableOne {
    //    We use uint256 in UserInfo
    using SafeMath for uint256;

    //    if miner creates contract with timestamp = 0, nobody can delete him. Changed timestamp to boolean value
    struct UserInfo {
        bool created;
        uint256 ether_balance;
    }

    mapping(address => UserInfo) public users_map;
    mapping(address => bool) is_super_user;
    address[] users_list;
    modifier onlySuperUser() {
        require(is_super_user[msg.sender] == true);
        _;
    }
    bool[] private lockUserBalances;

    event UserAdded(address new_user);

    constructor() public {
        set_super_user(msg.sender);
        add_new_user(msg.sender);
    }

    //    Only superuser can mark other users as superusers
    function set_super_user(address _new_super_user) public onlySuperUser {
        is_super_user[_new_super_user] = true;
    }

    //    We use SafeMath for uint256 - we don't need to check that balance was increased
    function pay() public payable {
        require(users_map[msg.sender].created == true);
        users_map[msg.sender].ether_balance += msg.value;
    }

    //    if miner creates contract with timestamp = 0, nobody can delete him
    function add_new_user(address _new_user) public onlySuperUser {
        require(users_map[_new_user].created == false);
        users_map[_new_user] = UserInfo({created : true, ether_balance : 0});
        users_list.push(_new_user);
    }

    //    Logic Bugs
    //    We don't need users list - test "add and remove users" checked that function isn't correct
    //    Also we don't know who can delete users - there is no information about it in TZ
    function remove_user(address _remove_user) public {
        require(users_map[msg.sender].created == true);
        delete (users_map[_remove_user]);
    }

    //    Cross-function Race Conditions
    //    'msg.sender.transfer' - is function from another contract. We don't actually know what happen in that contract.
    //    This function 'withdraw' can be called several times during first line execution - it's not safety
    function withdraw() public {
        users_map[msg.sender].ether_balance = 0;
        msg.sender.transfer(users_map[msg.sender].ether_balance);
    }

    function get_user_balance(address _user) public view returns (uint256) {
        return users_map[_user].ether_balance;
    }

    function is_i_super_user() public view returns (bool) {
        return is_super_user[msg.sender];
    }

    function is_user_super_user(address user) public view returns (bool) {
        return is_super_user[user];
    }

}