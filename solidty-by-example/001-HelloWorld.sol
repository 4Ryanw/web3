// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
contract SayHelloWorld{
string str = "Hello World";
	//声明结构体
	struct Info{
		string phrase;
		uint256 id;
		address addr;
	}
	//声明映射
	mapping(uint256 => Info ) infoMapping;	 

   function addInfo(string memory newString) public  pure returns(string memory){
   return string.concat(newString,"test");
   }

	function sayHello(uint256 _id) public view returns(string memory){
	 //判断是否找到对应id结构体
     if( infoMapping[_id].addr == address(0x0)){
      return addInfo(str);
     }else{
      return addInfo(infoMapping[_id].phrase);
     }
  }
	
	function setHelloWorld(string memory newString,uint256 _id) public {
        //msg是环境变量
	Info memory info = Info(newString,_id,msg.sender);
	//将结构体变量永久存储在合约
	//infos.push(info);
	infoMapping[_id] = info;
	}
}