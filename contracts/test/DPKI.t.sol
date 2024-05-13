// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import "forge-std/Test.sol";
import {
    DPKIContract,
    CertificateAuthorityIssued,
    CertificateAuthorityRevoked,
    ErrCertificateAuthorityNotFound
} from "../src/DPKI.sol";

contract DPKIContractTest is Test {
    address constant ADMIN_ADDRESS = address(169);

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
}
