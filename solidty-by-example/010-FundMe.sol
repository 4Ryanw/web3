// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//1、创建一个收款函数可以收款 
//2、记录投资人并查看
//3、在锁定期内，当筹款达到目标值生产商可以提款
//4、在锁定期内，未达到目标值投资人可以退款
contract FundMe{

    mapping(address=>uint256) public funderToAmount;
    uint256 MINIMUM_VALUE = 50*(10**18); //最小值100美元
    AggregatorV3Interface internal dataFeed;
    //定义目标
    uint256 constant TARGET = 1000*10**18;
    address public owner ;
    //unix时间戳标准
    uint256 deploymentTimestamp;
    uint256 lockTime;
    address erc20Addr;
    bool public getFundSuccess = false;
    //构造函数 
    constructor(uint256 _lockTime){
        //sepolia 测试网
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        owner = msg.sender;
        //当前区块的时间点
        deploymentTimestamp = block.timestamp;
        //设置锁定时间
        lockTime = _lockTime;
    }
    
        //payable关键字 表示该函数可以收取链上的原生通证
    //1.收款函数
    //只能在锁定期内调用
    function fund() external  payable {
        require(block.timestamp<=deploymentTimestamp+lockTime,"window is closed");
         //msg全局变量 sender=投送人 ， value=投送数量
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
    // 入参N个wei 返回的是价值 m 单位是10**18美元
    function   convertETH2USD(uint256 ethAmount) public view returns(uint256){
        //这里的price指的是一个ETH值多少个USD ,有精确度precision ETH对USD 的精确度为10**8  ,换句话说这里chainLink预言机返回的price单位是 10^8*$/ETH 
        uint256 ethPrice =  uint256(getChainlinkDataFeedLatestAnswer()) ;
        return ethAmount * ethPrice/(10 ** 8);
    }

    function transferOwnership(address newOwner) public ownerOnly{
        owner = newOwner;
    }

        //取款
    function getFund()  external windowClose ownerOnly{
        //this关键字 表示当前合约
        //balance 单位是wei 需要转换成美元
        require(convertETH2USD(address(this).balance) >= TARGET,"Targer is not reached");
        //transfer：transfer ETH revert if tx failed 纯转账
        payable (msg.sender).transfer(address(this).balance);
        // send 纯转账 会返回执行结果 布尔类型
         // eg: bool success =  payable (msg.sender).send(address(this).balance);
        // call 转账过程中调用函数 ，兼容transfer和send， 官方建议都用call
        // 若调用的函数有返回值则可以将返回值一并返回，并且会返回一个交易成功与否的bool
        bool  success;
          (success,) = payable (msg.sender).call{value: address(this).balance}("");
        getFundSuccess = success;
    }

    function refund() external windowClose{
        //目标值检测
        require(convertETH2USD(address(this).balance)< TARGET,'Target is reached' );
        uint256 amount =  funderToAmount[msg.sender];
        //投资金额检查
        require(amount != 0,"there is no found for you ");
          bool  success;
         (success,) = payable (msg.sender).call{value: amount}("");
         require(success,"transfer is failed!");
         funderToAmount[msg.sender] = 0;

    }

    function setFunderToAmount(address funder ,uint256 amountToUpdate) external  {
            require(msg.sender == erc20Addr,"You do not have permission to call this function");
            funderToAmount[funder] = amountToUpdate;
    }

    function setErc20Add(address _erc20Addr) public ownerOnly{
        erc20Addr =_erc20Addr;
    }

    modifier windowClose(){
        require(block.timestamp>=deploymentTimestamp+lockTime,"window is not closed");
        _; //下划线的位置表明后续代码执行的顺序和require的优先级

    }

    modifier ownerOnly(){
        require(msg.sender == owner,"this function can only be called by owner");
        _;
    }

}