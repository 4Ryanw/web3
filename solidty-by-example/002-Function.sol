
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
contract Counter{
    //uint初始默认值是0
    uint  count = 3;

    function get() public view returns (uint){
        return count ;
    }

    function incr() public {
        count += 1;
    }
      function decr() public {
        count -= 1;
    }
}