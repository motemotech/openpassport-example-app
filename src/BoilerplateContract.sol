// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {IOpenPassportVerifier} from "@openpassport-contracts/interfaces/IOpenPassportVerifier.sol";
import {IGenericVerifier} from "@openpassport-contracts/interfaces/IGenericVerifier.sol";
import {IBoilerplateContract} from "./IBoilerplateContract.sol";
import "@openpassport-contracts/libraries/OpenPassportAttributeSelector.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract BoilerplateContract is ERC721Enumerable, IBoilerplateContract {
    
    IOpenPassportVerifier public openPassportVerifier;

    MinimumAge public minimumAge;
    Nationality public nationality;
    Ofac public ofac;
    ExcludeCountries public excludeCountries;

    constructor(
        address _openPassportVerifier,
        MinimumAge memory _minimumAge,
        Nationality memory _nationality,
        Ofac memory _ofac,
        ExcludeCountries memory _excludeCountries
    ) ERC721("OpenPassport", "OpenPassport") {
        openPassportVerifier = IOpenPassportVerifier(_openPassportVerifier);
        minimumAge = _minimumAge;
        nationality = _nationality;
        ofac = _ofac;
        excludeCountries = _excludeCountries;
    }

    function verify(
        uint256 proveVerifierId,
        uint256 dscVerifierId,
        IGenericVerifier.ProveCircuitProof memory pProof,
        IGenericVerifier.DscCircuitProof memory dProof
    ) public returns (IOpenPassportVerifier.PassportAttributes memory) {
        uint256[] memory selectors = new uint256[](4);
        uint256  index = 0;

        if (minimumAge.enabled) {
         selectors[index++] = OpenPassportAttributeSelector.OLDER_THAN_SELECTOR;
        }
        if (nationality.enabled) {
            selectors[index++] = OpenPassportAttributeSelector.NATIONALITY_SELECTOR;
        }
        if (ofac.enabled) {
            selectors[index++] = OpenPassportAttributeSelector.OFAC_RESULT_SELECTOR;
        }
        if (excludeCountries.enabled) {
            selectors[index++] = OpenPassportAttributeSelector.FORBIDDEN_COUNTRIES_SELECTOR;
        }

        uint256 combinedSelector = OpenPassportAttributeSelector.combineAttributeSelectors(selectors);
        
        IOpenPassportVerifier.PassportAttributes memory passportAttributes = openPassportVerifier.verifyAndDiscloseAttributes(
            proveVerifierId, 
            dscVerifierId, 
            pProof, 
            dProof,
            combinedSelector
        );

        return passportAttributes;
    }

    function mint(
        uint256 proveVerifierId,
        uint256 dscVerifierId,
        IGenericVerifier.ProveCircuitProof memory pProof,
        IGenericVerifier.DscCircuitProof memory dProof
    ) public {

    }

}