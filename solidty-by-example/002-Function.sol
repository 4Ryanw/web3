
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
contract HelloWorld{
string  str = 'Hello World!';
/**
* 1.关键字function,声明这是一个函数
* 2.函数名
* 3.入参 
* 4.权限修饰符 见4.1
* 5.函数功能关键字（view、pure等）
* 6.若有返回值，关键字returns+返回数据类型
* 7.存储模式关键字 见4.2
*/
  //无入参 有返回值的函数 view - 纯读取函数
  function sayHello() public view returns(string memory){
			return   addinfo(str);
		}
   //有入参 无返回值的函数 修改变量的函数
   function setHelloWorld(string memory newString) public{
   	str = newString;
   }
    //有入参和返回值 纯函数（只有计算功能，不读取或修改变量）
   function addinfo(string memory newString) internal pure returns(string memory){

   return string.concat(newString,"test");
   }
}