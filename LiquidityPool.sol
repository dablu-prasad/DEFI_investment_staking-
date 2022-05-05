// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./ReservePool.sol";


contract LiquidityPool{
    address public owner;
    Mindpay public mindpay;

    receive() external payable{
        _requireReservePool();
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "Not owner!!");
        _;
    }    

    constructor(){
        owner = msg.sender;
        }

    ReservePool public reservepool;

    function setAddress(address payable _reservepool) external onlyOwner{
        reservepool = ReservePool(_reservepool);
    }

    function _requireReservePool() internal view{
        require(msg.sender == address(reservepool), "Only reservepool address");
    } 

    function getBalance() external view returns(uint bal){
      return bal = address(this).balance;
    }

}