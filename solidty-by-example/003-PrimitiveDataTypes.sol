
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Primitive{
    //默认false
    bool public  boo ; 
    // uint 非负整数 = uint256  
    uint a = 25; 
    //uint8 即8位的非负整数 能表示最大值=2^8 -1 = 255;
    uint8 u8 = 255;
    
    //int 整数 =int256 
    int i = -1;
    //int8 8位的整数 ，表示范围 -2^7 ~ (2^7 - 1)
    int8 i8 = -128;
    //address地址类型  默认值 0x0000000000000000000000000000000000000000
    address public add  = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    //bytes 一个字节
    bytes1 public by  =  0x8b;
}