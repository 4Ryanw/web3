// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


//2.让FundMe的参与者transfer通证
//3.在使用完成后burn掉通证
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./010-FundMe.sol";
contract FundTokenErc20  is ERC20{
    FundMe fundMe;
    constructor(address fundMeAddr) ERC20("FundTokenErc20","FT"){
        //把合约地址转化为对应实例 不同于new
        fundMe = FundMe(fundMeAddr);
    }
    
    //1.让FundMe的参与者基于mapping领取相应数量的通证
    function mint(uint256 amountToMint) public {
        require(fundMe.funderToAmount(msg.sender) >= amountToMint,"You cannot mint this many tokens");
        require(fundMe.getFundSuccess(),"the fundme is not completed yet");
        _mint(msg.sender, amountToMint);
        //减去fundme中的数量
        fundMe.setFunderToAmount(msg.sender,fundMe.funderToAmount(msg.sender)-amountToMint);
    }

    function claim(uint256 amountToClaim) public {
        require(balanceOf(msg.sender) >= amountToClaim, "You dont have enough ERC20 tokens");
        _burn(msg.sender, amountToClaim);
    }

}