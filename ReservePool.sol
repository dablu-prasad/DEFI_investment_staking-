// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./LiquidityPool.sol";
import "./StakingPool.sol";

contract ReservePool is Mindpay{

    receive() external payable{
        // _minValue();
        // invest();
    }


    LiquidityPool public liquidity;

    StakingPool public staking;

    mapping (address => uint) lockTime; //LockTime
    mapping(address => uint) public ReserveBalances; //90%
    mapping(address => uint) public LiquidityBalance; //10%

    constructor(address payable _liquidity, address _staking){
        liquidity = LiquidityPool(_liquidity);
        staking = StakingPool(_staking);
    }
    
    function invest() public payable{
        require(msg.value >=1, "ETH value is leass than 1 ETH");

        uint reserveAmount = (msg.value * 90)/100;
        lockTime[msg.sender] = block.timestamp + 20 seconds;
       
        ReserveBalances[msg.sender] += reserveAmount; //90%

        uint liquidAmount = msg.value - reserveAmount; //100% - 90% = 10%
        LiquidityBalance[msg.sender] += liquidAmount;

        (bool success, ) = address(liquidity).call{value:liquidAmount}("");
        require(success, "Sending ETH to LiquidityPool failed");

        // payable(address(liquidity)).transfer(liquidAmount);

        uint n = msg.value / 1 ether;
        uint tokenAmount = n * 1000 * 10**18;

        if( msg.value > 1 ether && msg.value < 5 ether){
            uint bonus = tokenAmount + (tokenAmount * 10)/100 ;

            _mint(msg.sender, bonus);
        }
        else if(msg.value > 5 ether){
            uint bonus = tokenAmount + (tokenAmount * 20)/100 ;

            _mint(msg.sender, bonus);
        }
    }

    function CancelInvestment() external {
        require(ReserveBalances[msg.sender] > 0, "insufficient funds");

        require(block.timestamp > lockTime[msg.sender], "lock time has not expired");


        //to avaoid reeentrancy attack we are doing accounting first and then transfer of value
        uint amount = ReserveBalances[msg.sender];
        ReserveBalances[msg.sender] = 0;

        uint tokenBalance = balanceOf(msg.sender);
        // mindpay.approve(address(this), tokenBalance); 
        // mindpay.burnFrom(msg.sender, tokenBalance);

        _burn(msg.sender, tokenBalance);

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send ether");

    }

    function stake() external{
        require(ReserveBalances[msg.sender] > 0, "insufficient funds");

        require(block.timestamp > lockTime[msg.sender], "lock time has not expired");

        uint amount = ReserveBalances[msg.sender];
        ReserveBalances[msg.sender] = 0;

        uint tokenBalance = balanceOf(msg.sender); 

        // mindpay.approve(address(this), tokenBalance);
        // mindpay.transferFrom(msg.sender, address(staking), tokenBalance );
        _transfer(msg.sender, address(staking), tokenBalance );

        (bool sent, ) = address(liquidity).call{value: amount}("");
        require(sent, "Failed to send ether");
    }
    
    
//     function _minValue() internal view{
//             require(msg.value >=1, "ETH value is leass than 1 ETH");
//         }
}