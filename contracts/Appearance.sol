// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Library.sol";

contract Appearance is Ownable {

    mapping(uint256 => string) public aliveStages;
    mapping(uint256 => string) public deadStages;

    struct State {
        bool isAlive;
        uint256 growthStage;
        uint256 hatchedAt;        
        uint256 lastFed;
        uint256 killCount;
        string colorOne;
        string colorTwo;
    }    

    function SVG(State memory petState)
        public
        view
        returns (string memory)
    {

        string memory svgString = string(
            abi.encodePacked(

                "<svg viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'>",
                "<rect fill='black' x='0' y='0' width='100' height='100' rx='5' ry='5' />",
                "<style>",
                ".colorOne { fill:", petState.colorOne, "; }",
                ".colorTwo { fill:", petState.colorTwo, "; }",
                "</style>",
                generateStatsSVG(petState),
                "<g transform='translate(20, 20), scale(4)'>",
                generatePetSVG(petState),
                "</svg>")
        );

        return svgString;
    }

    function generateStatsSVG(State memory petState)
        internal
        view
        returns (string memory)
    {
        string memory svgString;

        if (petState.growthStage > 0) {
           svgString = string(
            abi.encodePacked(
                "<text x='10' y='20' text-anchor='start' font-size='15' fill='white'>&#x2764;</text>",
                "<text x='90%' y='20' text-anchor='end' font-size='10' fill='white'>&#x1F480;", Library.toString(petState.killCount),"</text>",  
                "<rect x='10' y='5' width='30' height='", Library.toString(healthToHeight(petState)), "' fill='black'></rect>"
                ));
        }
       
        return svgString;
    }

    function generatePetSVG(State memory petState)
        internal
        view
        returns (string memory)
    {
        if (petState.isAlive) {
            return aliveStages[petState.growthStage];
        } else {
            return deadStages[petState.growthStage];
        }
    }

    function healthToHeight(State memory petState)
        internal
        view
        returns (uint256)
    {
        if (!petState.isAlive) {
            return 17;
        } 

        uint256 hoursSinceFed = (block.timestamp - petState.lastFed) / 1 hours;

        if (hoursSinceFed == 0) {
            return 0;
        }

        uint256 height = 17 - ((hoursSinceFed * 7083) / 10000);  
        return height;
            
    }

    function updateAliveStage(uint256 stageId, string memory svg)
        public
        onlyOwner
    {
        aliveStages[stageId] = svg;
    }

    function updateDeadStage(uint256 stageId, string memory svg)
        public
        onlyOwner
    {
        deadStages[stageId] = svg;
    }


}