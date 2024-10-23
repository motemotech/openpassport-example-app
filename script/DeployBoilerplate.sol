// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Script.sol";
import "../src/Boilerplate.sol";
import {IBoilerplate} from "../src/IBoilerplate.sol";

contract DeployBoilerplateScript is Script {
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        address openPassportVerifier = vm.envAddress("OPEN_PASSPORT_VERIFIER");

        IBoilerplate.MinimumAge memory minimumAge = IBoilerplate.MinimumAge({
            enabled: true,
            minimumAge: 18
        });

        IBoilerplate.Nationality memory nationality = IBoilerplate.Nationality({
            enabled: true,
            nationality: "FRA"
        });

        IBoilerplate.Ofac memory ofac = IBoilerplate.Ofac({
            enabled: true,
            ofac: false
        });

        bytes3[] memory excludeCountriesList = new bytes3[](20);
        excludeCountriesList[0] = 0x656565;

        IBoilerplate.ExcludeCountries memory excludeCountries = IBoilerplate.ExcludeCountries({
            enabled: true,
            excludeCountries: excludeCountriesList
        });

        // Deploy the Boilerplate contract
        Boilerplate boilerplate = new Boilerplate(
            openPassportVerifier,
            minimumAge,
            nationality,
            ofac,
            excludeCountries
        );

        // Optionally, you can output the deployed address
        console.log("Boilerplate deployed at:", address(boilerplate));

        // Stop broadcasting transactions
        vm.stopBroadcast();
    }
}