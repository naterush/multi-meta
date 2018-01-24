pragma solidity ^0.4.17;

import "./TxRelay.sol";
import "./BytesLib.sol";

contract MultiMeta2 {
  using BytesLib for bytes;

  TxRelay relay;

  function MultiMeta2(address relayAddress) public {
    relay = TxRelay(relayAddress);
  }

  function send(
    bytes data,
    uint[] length,
    uint[] gas
  ) public {

    uint lastIndex = 0;
    for (uint i = 0; i < num; i++) {
      bytes memory txData = _data.slice(lastIndex, lastIndex + length[i]);

      relay.call.gas(gas[i])(txData); // this way, if the sub-call fails, this can continue
      // if the sub-call fails, this should be able to continue
      // This only makes sense if:
        // The senders of each txData are different. This way, the nonces can continue processing. 

      lastIndex = lastIndex + length[i]; // maybe + 1, or something ;)
    }
  }
}
