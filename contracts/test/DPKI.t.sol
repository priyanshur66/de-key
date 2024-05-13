// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "forge-std/Test.sol";
import {
    DPKIContract,
    KeyPairsState,
    CertificateAuthorityIssued,
    CertificateAuthorityRevoked,
    KeyPairIssued,
    KeyPairRevoked,
    ErrCertificateAuthorityNotFound,
    ErrKeyPairsStateNotFound
} from "../src/DPKI.sol";

contract DPKIContractTest is Test {
    address constant ADMIN_ADDRESS = address(69);
    address constant DEVICE_ADDRESS = address(96);

    DPKIContract public dpkiContract;

    function setUp() public {
        dpkiContract = new DPKIContract();
    }

    function test_CertificateAuthorities() public {
        string memory certificate = "<certificate>";
        string memory certificate2 = "<certificate2>";

        vm.startPrank(ADMIN_ADDRESS);

        // Check that we can't access not existing certificate.
        vm.expectRevert(ErrCertificateAuthorityNotFound.selector);
        dpkiContract.getCertificateAuthority(ADMIN_ADDRESS, 1);

        // Successfully add new certificate.
        vm.expectEmit(true, true, true, true);
        emit CertificateAuthorityIssued(ADMIN_ADDRESS, 1);
        dpkiContract.addCertificateAuthority(certificate);

        // Check that we can access existing certificate.
        string memory resCertificate = dpkiContract.getCertificateAuthority(ADMIN_ADDRESS, 1);
        assertEq(certificate, resCertificate);

        // Check that we can fetch all certificates.
        {
            vm.expectEmit(true, true, true, true);
            emit CertificateAuthorityIssued(ADMIN_ADDRESS, 2);
            dpkiContract.addCertificateAuthority(certificate2);
            string[] memory certificates = dpkiContract.fetchCertificateAuthoritiesByAdmin(ADMIN_ADDRESS);
            assertEq(2, certificates.length);
            assertEq(certificate, certificates[0]);
            assertEq(certificate2, certificates[1]);
        }

        // Revoke certificate authorities.
        {
            vm.expectRevert(ErrCertificateAuthorityNotFound.selector);
            dpkiContract.revokeCertificateAuthority(3);

            vm.expectEmit(true, true, true, true);
            emit CertificateAuthorityRevoked(ADMIN_ADDRESS, 1);
            dpkiContract.revokeCertificateAuthority(1);

            string[] memory certificates = dpkiContract.fetchCertificateAuthoritiesByAdmin(ADMIN_ADDRESS);
            assertEq(1, certificates.length);
            assertEq(certificate2, certificates[0]);
        }

        vm.stopPrank();
    }

    function test_KeyPairs() public {
        // Check that we can't access not existing key pairs.
        vm.expectRevert(ErrKeyPairsStateNotFound.selector);
        vm.prank(DEVICE_ADDRESS);
        dpkiContract.getKeyPairs();

        string memory keyPairHash = "<keyPairHash>";
        string memory cid = "<cid>";
        string memory cidFileHash = "<cidFileHash>";

        vm.expectEmit(true, true, true, true);
        emit KeyPairIssued(ADMIN_ADDRESS, DEVICE_ADDRESS, keyPairHash, cid, cidFileHash);
        vm.prank(ADMIN_ADDRESS);
        dpkiContract.addKeyPair(DEVICE_ADDRESS, keyPairHash, cid, cidFileHash);

        vm.prank(DEVICE_ADDRESS);
        KeyPairsState memory state = dpkiContract.getKeyPairs();
        assertEq(cid, state.cid);
        assertEq(cidFileHash, state.cidFileHash);

        string memory keyPairHash2 = "<keyPairHash2>";
        string memory cid2 = "<cid2>";
        string memory cidFileHash2 = "<cidFileHash2>";

        vm.expectEmit(true, true, true, true);
        emit KeyPairRevoked(ADMIN_ADDRESS, DEVICE_ADDRESS, keyPairHash2, cid2, cidFileHash2);
        vm.prank(ADMIN_ADDRESS);
        dpkiContract.revokeKeyPair(DEVICE_ADDRESS, keyPairHash2, cid2, cidFileHash2);

        vm.prank(DEVICE_ADDRESS);
        KeyPairsState memory state2 = dpkiContract.getKeyPairs();
        assertEq(cid2, state2.cid);
        assertEq(cidFileHash2, state2.cidFileHash);
    }
}
