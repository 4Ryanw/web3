// SPDX-License-Identifier: MIT
pragma solidity 0.8;

contract  Immutable{

    address public immutable myadd ;
    uint public immutable number;

//构造函数
    constructor(){
            myadd = msg.sender;
            number = 200;
    }

}