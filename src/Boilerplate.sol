// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {IOpenPassportVerifier} from "@openpassport-contracts/interfaces/IOpenPassportVerifier.sol";
import {IGenericVerifier} from "@openpassport-contracts/interfaces/IGenericVerifier.sol";
import {OpenPassportConstants} from "@openpassport-contracts/constants/OpenPassportConstants.sol";
import {IBoilerplate} from "./IBoilerplate.sol";
import "@openpassport-contracts/libraries/OpenPassportAttributeSelector.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openpassport-contracts/libraries/OpenPassportAttributeHandler.sol";

contract Boilerplate is ERC721Enumerable, IBoilerplate {

    error SBT_CAN_NOT_BE_TRANSFERED();
    
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
        IOpenPassportVerifier.OpenPassportAttestation memory attestation
    ) public returns (IOpenPassportVerifier.PassportAttributes memory) {
        
        // Set the selectors for the attributes to be disclosed
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
        
        // Call OpenPassportVerifier
        IOpenPassportVerifier.PassportAttributes memory passportAttributes = openPassportVerifier.verifyAndDiscloseAttributes(
            attestation,
            combinedSelector
        );

        return passportAttributes;
    }

    function mint(
        IOpenPassportVerifier.OpenPassportAttestation memory attestation
    ) public {
        IOpenPassportVerifier.PassportAttributes memory passportAttributes = verify(attestation);
        address addr = address(uint160(OpenPassportAttributeHandler.extractUserIdentifier(attestation)));
        uint256 newTokenId = totalSupply();
        _mint(addr, newTokenId);
    }

    function _update(address to, uint256 tokenId, address auth) internal override returns (address) {
        if (to != address(0)) {
            revert SBT_CAN_NOT_BE_TRANSFERED();
        }

        return super._update(to, tokenId, auth);
    }

}