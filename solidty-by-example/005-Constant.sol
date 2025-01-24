// SPDX-License-Identifier: MIT
pragma solidity 0.8;

contract Constants{
    //constant 修饰符代表变量不能被修改，存储时可以节省gas消耗
    address public constant MY_ADDRESS = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    uint public constant MY_UINT  = 123;

    function test() public payable returns(uint256){
            return msg.value;
    }
}