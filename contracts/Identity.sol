pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2;

import './ClaimHolder.sol';

contract Identity is ClaimHolder {

    function Identity(
        uint256[] _claimType,
        uint256[] _scheme,
        address[] _issuer,
        bytes _signature,
        bytes32[] _data,
        string _uri,
        uint256[] _sigSizes,
        uint256[] uriSizes
    )
        public
    {
        bytes32 claimId;
        uint offset = 0;
        uint uoffset = 0;

        for (uint i = 0; i < _claimType.length; i++) {

            claimId = keccak256(_issuer[i], _claimType[i]);

            claims[claimId] = Claim(
                _claimType[i],
                _scheme[i],
                _issuer[i],
                getBytes(_signature, offset, _sigSizes[i]),
                _data[i],
                getString(_uri, uoffset, uriSizes[i])
            );

            offset += _sigSizes[i];
            uoffset += uriSizes[i];

            emit ClaimAdded(
                claimId,
                claims[claimId].claimType,
                claims[claimId].scheme,
                claims[claimId].issuer,
                claims[claimId].signature,
                claims[claimId].data,
                claims[claimId].uri
            );
        }
    }

    function getBytes(bytes _str, uint256 _offset, uint256 _length) constant returns (bytes) {
        bytes memory sig = new bytes(_length);
        uint256 j = 0;
        for (uint256 k = _offset; k< _offset + _length; k++) {
          sig[j] = _str[k];
          j++;
        }
        return sig;
    }

    function getString(string _str, uint256 _offset, uint256 _length) constant returns (string) {
        bytes memory strBytes = bytes(_str);
        bytes memory sig = new bytes(_length);
        uint256 j = 0;
        for (uint256 k = _offset; k< _offset + _length; k++) {
          sig[j] = strBytes[k];
          j++;
        }
        return string(sig);
    }
}
