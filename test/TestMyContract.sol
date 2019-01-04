/* Testing with solidity tests. */
pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MyContract.sol";

contract MyContractWrapper is MyContract{
  function callStoreNum(uint num) public{
    storeNum(num);
  }
}

contract TestMyContract {

  function testInitialStoredValue() public{
      MyContract mycontract = new MyContractWrapper();

      uint expected = 24;

      Assert.equal(mycontract.mynumber(), expected, "First number set should be 24.");
  }

  function testTheThrow() public{
      MyContractWrapper mycontract = new MyContractWrapper(); 

      ThrowProxy throwproxy = new ThrowProxy(address(mycontract)); 

      MyContractWrapper(address(throwproxy)).callStoreNum(7);

      (bool r, ) = throwproxy.execute.gas(200000)(); 

      Assert.isFalse(r, "Should be false because is should throw!");
      Assert.equal(mycontract.mynumber(), 24, "Should not have changed");

  }

  function testNoThrow() public{
      MyContract mycontract = new MyContractWrapper(); 

      ThrowProxy throwproxy = new ThrowProxy(address(mycontract)); 

      MyContractWrapper(address(throwproxy)).callStoreNum(22);

      (bool r, ) = throwproxy.execute.gas(200000)(); 

      Assert.isTrue(r, "Should be true because is should throw!");
      Assert.equal(mycontract.mynumber(), 22, "Should have changed");
  }

}

// Proxy contract for testing throws
contract ThrowProxy {
  address public target;
  bytes data;

  constructor(address _target) public{
    target = _target;
  }

  //prime the data using the fallback function.
  function() external{
    data = msg.data;
  }

  function execute() public returns (bool, bytes memory) {
    return target.call(data);
  }
}
