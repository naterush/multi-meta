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
    uint8[] sigV,
    bytes32[] sigR,
    bytes32[] sigS,
    address[] destination,
    bytes data,
    address[] listOwner,
    uint dataLength
  ) public {
    uint num = sigV.length;

    require(
      num == sigR.length &&
      num == sigS.length &&
      num == destination.length &&
      num == listOwner.length
    );

    uint lastIndex = 0;
    for (uint i = 0; i < num; i++) {
      uint length = dataLength[i];

      bytes memory txData = _data.slice(lastIndex, lastIndex + length);

      relay.relayMetaTx(
        sigV[i],
        sigR[i],
        sigS[i],
        destination[i],
        txData,
        listOwner[i]
      );
      // this assumes that none of the transactions will fail.

      lastIndex = lastIndex + length; // maybe + 1, or something ;)
    }
  }
}
