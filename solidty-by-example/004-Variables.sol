// SPDX-License-Identifier: MIT
pragma solidity 0.8;

contract Variables{
    //通过内置的type函数获取当前类型的最大值/最小值
    uint8 public u8 = type(uint8).max;

    //1.local 函数中 2.state 存在链上，要消耗gas  3.global 全局的 整个以太坊全局
    string public testStr = "Hello,friend";

    function test() public  view returns(uint){
        uint time = block.timestamp; //全局变量
        return  time;
    }

    function getAddr() public view returns(address){
        return msg.sender;
    }

    function getMap() public view returns(address,uint){
        return (msg.sender,block.timestamp);
    }

}