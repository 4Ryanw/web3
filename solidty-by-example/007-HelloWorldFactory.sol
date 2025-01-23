// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
//第一注引入形式
import {SayHelloWorld} from "./001-HelloWorld.sol";
//第二种引入形式 需要保证有访问权限
//import {xxx} from "https://github.com.xxxxx.url.sol";
//第三种引入形式 第三方包
//import {xxx} from "@company_name.xxx.sol";


contract HelloWorldFactory{
    SayHelloWorld  hw;
    SayHelloWorld[] hws;
     function createHelloWorld() public {
        hw = new SayHelloWorld();
        hws.push(hw);
     } 

     function getHelloWorldByIndex(uint256 _index) public view returns (SayHelloWorld){
        return hws[_index];
     }

     function callSayHellow(uint256 _index ,uint256 _id) public view returns(string memory){
       return hws[_index].sayHello(_id);
     }
     function callSet(uint256 _index ,string memory newString,uint256 _id) public {
        hws[_index].setHelloWorld(newString,_id);
     }
}