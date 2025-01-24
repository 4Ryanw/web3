// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    mapping(address=>uint256) public funderToAmount;
    uint256 MINIMUM_VALUE = 50*(10**18); //最小值100美元
    AggregatorV3Interface internal dataFeed;
    //构造函数 
    constructor(){
        //sepolia 测试网
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        
    }
    
    function fund() external  payable {
        //校验转账金额
       require(convertETH2USD(msg.value) >= MINIMUM_VALUE,"send me more!!");
        //记录转账人
        funderToAmount[msg.sender] = msg.value;

    }


  function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

    // 将转账金额计算转化为usd
    //1 ETH = 1000 FINNEY = 10**9 GWEI = 10**18WEI
    // 入参N个wei 返回的是价值x美元
    function   convertETH2USD(uint256 ethAmount) public view returns(uint256){
        //这里的price指的是一个ETH值多少个USD ,有精确度precision ETH对USD 的精确度为10**8  ,换句话说这里chainLink预言机返回的price单位是 10^8*$/ETH 
        uint256 ethPrice =  uint256(getChainlinkDataFeedLatestAnswer()) ;
        return ethAmount * ethPrice/(10 ** 8);
    }

}