// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FundToken{
    //1.token名字
    string public tokenName;
    //2.简称
    string public tokenSymbol;
    //3.发行数量
    uint256 public totalSupply;
    //4.owner
    address public owner;
    //5.balance address->uin256
    mapping (address =>uint256) public balances;

    constructor(string memory _tokenName,string memory _tokenSymbol){
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        owner = msg.sender;
    }
    //mint :铸造token到某个地址
    function mint(uint256 amountToMint) public{
            balances[msg.sender] = amountToMint;
            totalSupply += amountToMint;
    }
    //transfer：转移token
    function transfer(address payee,uint256 amount) public {
        require(balances[msg.sender]>= amount,"You do not enough balance to transfer");
        balances[msg.sender] -= amount;
        balances[payee] += amount;
    }
    //balanceOf：查看某一个地址通证数量
    function balancesOf(address addr) public view returns(uint256 ){
            return balances[addr];
    }
}