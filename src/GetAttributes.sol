// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {IOpenPassportVerifier} from "@openpassport-contracts/interfaces/IOpenPassportVerifier.sol";
import {IGenericVerifier} from "@openpassport-contracts/interfaces/IGenericVerifier.sol";

contract CheckOlderThan {
    
    IOpenPassportVerifier public openPassportVerifier;

    constructor(address _openPassportVerifier) {
        openPassportVerifier = IOpenPassportVerifier(_openPassportVerifier);
    }

    function checkOlderThan(
        uint256 prove_verifier_id,
        uint256 dsc_verifier_id,
        IGenericVerifier.ProveCircuitProof memory p_proof,
        IGenericVerifier.DscCircuitProof memory d_proof
    ) public returns (uint256) {
        IOpenPassportVerifier.DiscloseSelector memory discloseSelector = IOpenPassportVerifier.DiscloseSelector({
            extractIssuingState: false,
            extractName: false,
            extractPassportNumber: false,
            extractNationality: false,
            extractDateOfBirth: false,
            extractGender: false,
            extractExpiryDate: false,
            extractOlderThan: true
        });
        IOpenPassportVerifier.PassportAttributes memory attributes;
        attributes = openPassportVerifier.getAttributes(prove_verifier_id, dsc_verifier_id, p_proof, d_proof, discloseSelector);
        return attributes.olderThan;
    }

    function getNationality(
        uint256 prove_verifier_id,
        uint256 dsc_verifier_id,
        IGenericVerifier.ProveCircuitProof memory p_proof,
        IGenericVerifier.DscCircuitProof memory d_proof
    ) public returns (string memory) {
        IOpenPassportVerifier.DiscloseSelector memory discloseSelector = IOpenPassportVerifier.DiscloseSelector({
            extractIssuingState: false,
            extractName: false,
            extractPassportNumber: false,
            extractNationality: true,
            extractDateOfBirth: false,
            extractGender: false,
            extractExpiryDate: false,
            extractOlderThan: false
        });
        IOpenPassportVerifier.PassportAttributes memory attributes;
        attributes = openPassportVerifier.getAttributes(prove_verifier_id, dsc_verifier_id, p_proof, d_proof, discloseSelector);
        return attributes.nationality;
    }
}