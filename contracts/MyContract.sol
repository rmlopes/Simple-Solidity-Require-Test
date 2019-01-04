pragma solidity ^0.5.0;

contract MyContract {

    uint public mynumber; 
    /* Modified simple storage function. Only stores numbers greater than 10. */
    
    modifier checkValue(uint mynum){ 
     require(mynum > 10); _;}

    constructor() public{
        mynumber = 24; 
    }

    function storeNum(uint mynum)
        public
        checkValue(mynum)
    {
     mynumber = mynum; 
    }
}