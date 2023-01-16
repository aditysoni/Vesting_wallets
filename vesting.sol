// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC20/IERC20.sol";

 contract Vesting {
    IERC20 public token;    // token which is created by us 
    address public receiver;
    uint256 public amount;
    uint256 public expiry;
    bool public locked = false;
    bool public claimed = false;

    constructor (address _token) {// address of token is received 
        token = IERC20(_token);  // interface is sotred as token 
    }
    // 
    function lock(address _from, address _receiver, uint256 _amount, uint256 _expiry) external {
        require(!locked, "We have already locked tokens.");  //
        token.transferFrom(_from, address(this), _amount);  // transfers the token from the address to us 
        receiver = _receiver;  // storing the receiver 
        amount = _amount;
        expiry = _expiry;
        locked = true;
    }

    function withdraw() external {
        require(locked, "Funds have not been locked");
        require(block.timestamp > expiry, "Tokens have not been unlocked");
        require(!claimed, "Tokens have already been claimed");
        claimed = true;
        token.transfer(receiver, amount*2); // transfers the double amount he has locked 
    }
    

     
    // function getTime() external view returns (uint256) {
    //     return block.timestamp;
    // }
}
