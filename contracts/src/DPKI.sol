// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

error ErrCertificateAuthorityNotFound();

// Admin address and certificate authority id.
event CertificateAuthorityIssued(address indexed, uint256);

// Admin address and certificate authority id.
event CertificateAuthorityRevoked(address indexed, uint256);

contract DPKIContract {
    // Admin: id: certificate.
    mapping(address => mapping(uint256 => string)) certificateAuthorities;
    mapping(address => uint256) certificateAuthoritiesCount;
    mapping(address => uint256[]) certificateAuthoritiesIndex;

    constructor() {}

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
        removeFromIndex(id);

        emit CertificateAuthorityRevoked(msg.sender, id);
    }

    function removeFromIndex(uint256 id) private {
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
}
