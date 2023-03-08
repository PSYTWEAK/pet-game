// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StateOfPet  {

    mapping(uint256 => Pet) public pets;

    struct Pet {        
        bool isAlive;
        uint256 hatchedAt;
        uint256 lastFed;
        uint256 killCount;
        string colorOne;
        string colorTwo;
    }

    struct PetState {
        bool isAlive;
        uint256 growthStage;
        uint256 hatchedAt;        
        uint256 lastFed;
        uint256 killCount;
        string colorOne;
        string colorTwo;
    }


    function getGrowthStage(uint256 id) internal view returns (uint stage) {

        uint daysOld;
        if (isAlive(id)) {
            daysOld = (block.timestamp - pets[id].hatchedAt) / 1 days;
        } else {
        // if last fed is over 24 hours then growth stage is the age it was when it died
            daysOld = (block.timestamp - (pets[id].lastFed + 24 hours)) / 1 days;
        }

        if (daysOld < 3) {
            stage = 0;
        } else if (daysOld < 7) {
            stage = 1;
        } else {
            stage = 2;
        } 
    }

    function isAlive(uint256 id) internal view returns (bool) {
        if (block.timestamp - pets[id].lastFed > 24 hours) {
            return false;
        } else {
            return pets[id].isAlive;
        }
    }

    function petState(uint256 id) public view returns (PetState memory petState) {
        petState = PetState(isAlive(id), getGrowthStage(id), pets[id].lastFed, pets[id].hatchedAt, pets[id].killCount, pets[id].colorOne, pets[id].colorOne);
    }


}