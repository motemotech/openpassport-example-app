// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IVerifiersManager} from "@openpassport-contracts/interfaces/IVerifiersManager.sol";

contract CheckOlderThan {

    IVerifiersManager public verifiersManager;

    constructor(address _verifiersManager) {
        verifiersManager = IVerifiersManager(_verifiersManager);
    }

    

}