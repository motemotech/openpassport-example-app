// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {IOpenPassportVerifier} from "@openpassport-contracts/interfaces/IOpenPassportVerifier.sol";
import {IGenericVerifier} from "@openpassport-contracts/interfaces/IGenericVerifier.sol";
import "@openpassport-contracts/libraries/OpenPassportAttributeSelector.sol";

contract BoilerplateContract {
    
    IOpenPassportVerifier public openPassportVerifier;

    uint256 public minimumAge;
    string public nationality;
    bool public ofac;
    string[] public excludeCountries;

    constructor(address _openPassportVerifier) {
        openPassportVerifier = IOpenPassportVerifier(_openPassportVerifier);
    }

    function setMinimumAge(uint256 _minimumAge) public {
        if (_minimumAge < 10) {
            revert("Minimum age must be at least 10 years old");
        } else if (_minimumAge > 100) {
            revert("Minimum age must be at most 100 years old");
        }
        minimumAge = _minimumAge;
    }

    function setNationality(string memory _nationality) public {
        nationality = _nationality;
    }

    function setExcludeCountries(string[] memory _excludeCountries) public {
        excludeCountries = _excludeCountries;
    }

    function setOfac(bool _ofac) public {
        ofac = _ofac;
    }

}