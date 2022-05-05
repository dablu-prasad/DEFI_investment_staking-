// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./ReservePool.sol";
import "./Mindpay.sol";

contract StakingPool{
 
    Mindpay public mindpay;

    constructor(address payable _mindpay){
        mindpay = Mindpay(_mindpay);
    }

    function balanceOf(address _address) external view returns(uint){
        uint balance = mindpay.balanceOf(_address);
        return balance;
    }
}
