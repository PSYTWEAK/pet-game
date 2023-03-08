// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract Helper  {

    function randomBool(uint256 chanceA, uint256 chanceB) internal view returns (bool) {
        uint256 random = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender)));
        uint256 chance = random % (chanceA + chanceB);
        if (chance < chanceA) {
            return true;
        } else {
            return false;
        }
    }


    function generateColors() public view returns (string memory, string memory) {
        uint256 rand1 = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty))) % 16777216;
        uint256 rand2 = uint256(keccak256(abi.encodePacked(block.timestamp + 1, block.difficulty))) % 16777216;
        string memory color1 = Strings.toHexString(rand1);
        string memory color2 = Strings.toHexString(rand2);

        // change last two characters to FF
        bytes memory color1Bytes = bytes(color1);
        color1Bytes[0] = "";
        color1Bytes[1] = "#";
        color1Bytes[6] = "F";
        color1Bytes[7] = "F";
        color1 = string(color1Bytes);

        bytes memory color2Bytes = bytes(color2);
        color2Bytes[0] = "";
        color2Bytes[1] = "#";
        color2Bytes[6] = "F";
        color2Bytes[7] = "F";
        color2 = string(color2Bytes);
        
        return (color1, color2);
    }



}