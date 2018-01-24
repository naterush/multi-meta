pragma solidity ^0.4.17;

import "./TxRelay.sol";

contract MultiMeta {
  TxRelay relay;

  struct Transaction {
    bool sent;
    uint8 sigV;
    bytes32 sigR;
    bytes32 sigS;
    address destination;
    bytes data;
    address listOwner;
  }

  mapping (address => mapping (uint => Transaction)) transactions;

  function MultiMeta(address relayAddress) public {
    relay = TxRelay(relayAddress);
  }

  // NOTE: This might have some weird stuff w/ the whitelist that requires us to add access control...
  function send(
    uint8 _sigV,
    bytes32 _sigR,
    bytes32 _sigS,
    address _destination,
    bytes _data,
    address _listOwner,
    address add,
    uint nonce
  ) public {
    if (isExecutable(add, nonce)) {
      relay.relayMetaTx(
        _sigV,
        _sigR,
        _sigS,
        _destination,
        _data,
        _listOwner
      );
      transactions[add][nonce].sent = true;
    } else {
      transactions[add][nonce] = Transaction({
        sent: false,
        sigV: _sigV,
        sigR: _sigR,
        sigS: _sigS,
        destination: _destination,
        data: _data,
        listOwner: _listOwner
        });
    }
  }

  function isExecutable(address add, uint nonce) public view returns (bool) {
    if (nonce == 0) {
      return true;
    }
    return transactions[add][nonce - 1].sent;
  }
}
