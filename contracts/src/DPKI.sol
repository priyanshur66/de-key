// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

error ErrCertificateAuthorityNotFound();
error ErrKeyPairsStateNotFound();

event CertificateAuthorityIssued(address indexed admin, uint256 id);

event CertificateAuthorityRevoked(address indexed admin, uint256 id);

event KeyPairIssued(address indexed admin, address indexed device, string keyPairHash, string cid, string cidFileHash);

event KeyPairRevoked(address indexed admin, address indexed device, string keyPairHash, string cid, string cidFileHash);

// Latest CID with certificates and its hash.
struct KeyPairsState {
    string cid;
    string cidFileHash;
}

contract DPKIContract {
    // Admin: id: certificate.
    mapping(address => mapping(uint256 => string)) certificateAuthorities;
    // Admin: latest certificate id.
    mapping(address => uint256) certificateAuthoritiesCount;
    // Admin: certificate ids.
    mapping(address => uint256[]) certificateAuthoritiesIndex;

    mapping(address => KeyPairsState) keyPairsState;

    constructor() {}

    /*
        Certificate authority methods.
    */

    function addCertificateAuthority(string calldata certificate) external {
        uint256 count = certificateAuthoritiesCount[msg.sender];
        count++;
        certificateAuthoritiesCount[msg.sender] = count;

        certificateAuthorities[msg.sender][count] = certificate;
        certificateAuthoritiesIndex[msg.sender].push(count);

        emit CertificateAuthorityIssued(msg.sender, count);
    }

    function getCertificateAuthority(address admin, uint256 id) external view returns (string memory) {
        string memory certificate = certificateAuthorities[admin][id];
        // If certificate is empty it means it doesn't exist.
        if (bytes(certificate).length == 0) {
            revert ErrCertificateAuthorityNotFound();
        }
        return certificate;
    }

    // todo: improve this function with paging
    function fetchCertificateAuthoritiesByAdmin(address admin) external view returns (string[] memory) {
        mapping(uint256 => string) storage certificates = certificateAuthorities[admin];
        uint256[] memory index = certificateAuthoritiesIndex[admin];
        string[] memory ret = new string[](index.length);
        for (uint256 i = 0; i < index.length; i++) {
            ret[i] = certificates[index[i]];
        }
        return ret;
    }

    function revokeCertificateAuthority(uint256 id) external {
        string memory certificate = certificateAuthorities[msg.sender][id];
        // If certificate is empty it means it doesn't exist.
        if (bytes(certificate).length == 0) {
            revert ErrCertificateAuthorityNotFound();
        }

        delete certificateAuthorities[msg.sender][id];
        removeCertificateAuthorityIndex(id);

        emit CertificateAuthorityRevoked(msg.sender, id);
    }

    function removeCertificateAuthorityIndex(uint256 id) private {
        uint256[] storage index = certificateAuthoritiesIndex[msg.sender];
        for (uint256 i = 0; i < index.length; i++) {
            if (index[i] == id) {
                // Move the last element to the spot of the one to remove.
                index[i] = index[index.length - 1];
                // Remove the last element (target after move).
                index.pop();
                return;
            }
        }
    }

    /*
        Certificate authority methods.
    */

    /*
        Key pair methods.
    */

    function addKeyPair(address device, string calldata keyPairHash, string calldata cid, string calldata cidFileHash)
        external
    {
        keyPairsState[device] = KeyPairsState(cid, cidFileHash);
        emit KeyPairIssued(msg.sender, device, keyPairHash, cid, cidFileHash);
    }

    function getKeyPairs() external view returns (KeyPairsState memory) {
        KeyPairsState memory state = keyPairsState[msg.sender];
        if (bytes(state.cid).length == 0) {
            revert ErrKeyPairsStateNotFound();
        }
        return state;
    }

    function revokeKeyPair(
        address device,
        string calldata keyPairHash,
        string calldata cid,
        string calldata cidFileHash
    ) external {
        keyPairsState[device] = KeyPairsState(cid, cidFileHash);
        emit KeyPairRevoked(msg.sender, device, keyPairHash, cid, cidFileHash);
    }

    /*
        Key pair methods.
    */
}
