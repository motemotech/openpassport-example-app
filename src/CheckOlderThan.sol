// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IVerifiersManager} from "@openpassport-contracts/interfaces/IVerifiersManager.sol";
import {OpenPassportCircuitLibrary} from "@openpassport-contracts/libraries/CircuitLibrary.sol";

contract CheckOlderThan {

    error CURRENT_DATE_NOT_IN_VALID_RANGE();
    error UNEQUAL_BLINDED_DSC_COMMITMENT();
    error INVALID_PROVE_PROOF();
    error INVALID_DSC_PROOF();

    IVerifiersManager public verifiersManager;

    constructor(address _verifiersManager) {
        verifiersManager = IVerifiersManager(_verifiersManager);
    }

    function checkOlderThan(
        uint256 prove_verifier_id,
        uint256 dsc_verifier_id,
        IVerifiersManager.RSAProveCircuitProof memory p_proof,
        IVerifiersManager.DscCircuitProof memory d_proof
    ) public view returns (uint256) {

        // Check the timestamp in the p_proof is correct
        uint256[6] memory dateNum;
        for (uint i = 0; i < 6; i++) {
            dateNum[i] = p_proof.pubSignals[OpenPassportCircuitLibrary.PROVE_RSA_CURRENT_DATE_INDEX + i];
        }
        uint256 currentTimestamp = OpenPassportCircuitLibrary.getCurrentTimestamp(dateNum);
        if(
            currentTimestamp < block.timestamp - 1 days ||
            currentTimestamp > block.timestamp + 1 days
        ) {
            revert CURRENT_DATE_NOT_IN_VALID_RANGE();
        }

        // check blinded dcs
        if (
            keccak256(abi.encodePacked(p_proof.pubSignals[OpenPassportCircuitLibrary.PROVE_RSA_BLINDED_DSC_COMMITMENT_INDEX])) !=
            keccak256(abi.encodePacked(d_proof.pubSignals[OpenPassportCircuitLibrary.DSC_BLINDED_DSC_COMMITMENT_INDEX]))
        ) {
            revert UNEQUAL_BLINDED_DSC_COMMITMENT();
        }

        // check prove proof
        if (!verifiersManager.verifyWithProveVerifier(prove_verifier_id, p_proof)) {
            revert INVALID_PROVE_PROOF();
        }

        // check dsc proof
        if (!verifiersManager.verifyWithDscVerifier(dsc_verifier_id, d_proof)) {
            revert INVALID_DSC_PROOF();
        }

        uint[3] memory revealedData_packed;
        for (uint256 i = 0; i < 3; i++) {
            revealedData_packed[i] = p_proof.pubSignals[OpenPassportCircuitLibrary.PROVE_RSA_REVEALED_DATA_PACKED_INDEX + i];
        }
        bytes memory charcodes = OpenPassportCircuitLibrary.fieldElementsToBytes(
            revealedData_packed
        );

        uint256 olderThan = 
            OpenPassportCircuitLibrary.numAsciiToUint(p_proof.pubSignals[OpenPassportCircuitLibrary.PROVE_RSA_OLDER_THAN_INDEX])*10
            + OpenPassportCircuitLibrary.numAsciiToUint(p_proof.pubSignals[OpenPassportCircuitLibrary.PROVE_RSA_OLDER_THAN_INDEX + 1]);

        return olderThan;
    }

}