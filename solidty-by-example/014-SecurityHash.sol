// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 校验签名
contract VerifySig {
    
    function verify(
        address _signer,
        string memory _message,
        bytes memory _sig
    ) external pure returns (bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        
        return recover(ethSignedMessageHash, _sig) == _signer;
    }

    // 对 message 进行哈希计算，得到 messageHash
    function getMessageHash(string memory _message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    // 处理 messageHash，使其符合以太坊链上的格式
    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
    }

    // 从签名中恢复出签名者地址
    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);

        address recovered = ecrecover(_ethSignedMessageHash, v, r, s);
        require(recovered != address(0), "Invalid signature"); // 防止 ecrecover 失败

        return recovered;
    }

    // 拆分签名
    function _split(bytes memory _sig) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(_sig.length == 65, "Invalid signature length");

        assembly {
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }

        // 修正 v 值，确保符合 ecrecover 要求
        if (v < 27) {
            v += 27;
        }
    }
}
