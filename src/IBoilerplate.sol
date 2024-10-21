//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBoilerplate {

    struct MinimumAge {
        bool enabled;
        uint256 minimumAge;
    }

    struct Nationality {
        bool enabled;
        string nationality;
    }

    struct Ofac {
        bool enabled;
        bool ofac;
    }

    struct ExcludeCountries {
        bool enabled;
        bytes3[] excludeCountries;
    }

}
