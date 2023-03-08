// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Appearance.sol";
import "./StateOfPet.sol";
import "./Helper.sol";


contract Pet is ERC721, Appearance, StateOfPet, Helper {

    uint public totalSupply;

    constructor() ERC721("Pet Game", "PG") {}


    function collectEgg(address to) external {
        
        totalSupply++;

        uint256 thisTokenId = totalSupply;

        _mint(to, thisTokenId);  

        (string memory color1, string memory color2) = generateColors();

        Pet memory newPet = Pet(true, block.timestamp, block.timestamp + 2 days, 0, color1, color2);
        pets[thisTokenId] = newPet;

    }

    function feedPet(uint256 id) external {
        require(ownerOf(id) == msg.sender, "You do not own this pet");
        require(isAlive(id), "This pet is dead");
        require(getGrowthStage(id) > 0, "This pet hasn't hatch yet");

        pets[id].lastFed = block.timestamp;
    }

    function attackPet(uint256 attacker, uint256 victim) external {
        require(ownerOf(attacker) == msg.sender, "You do not own this pet");
        require(isAlive(attacker) && isAlive(victim), "One of the pets is already dead");
        require(getGrowthStage(attacker) > 0 && getGrowthStage(victim) > 0, "One of the pets hasn't hatch yet");

        uint attackerGrowthStage = getGrowthStage(attacker);
        uint victimGrowthStage = getGrowthStage(victim);

        bool attackerWon = randomBool(attackerGrowthStage, victimGrowthStage);

        if (attackerWon) {
            pets[victim].isAlive = false;
            pets[attacker].killCount++;
        } else {
            pets[attacker].isAlive = false;
            pets[victim].killCount++;
        }
    }

    /**
     * @dev Hash to metadata function
     */
    function metadata(uint tokenId)
        public
        view
        returns (string memory)
    {
        string memory metadataString = string(abi.encodePacked(
           "{'trait_type': 'kill count', 'value':'",
            Library.toString(pets[tokenId].killCount),
            "'},"));

        return string(abi.encodePacked("[", metadataString, "]"));
    }
    function returnsNumberONE() public 
    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        PetState memory petState = petState(tokenId);
    
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Library.encode(
                        bytes(
                            string(
                                abi.encodePacked(
                                    '{"name": "Message #',
                                    Library.toString(tokenId),
                                    '", "description": " Pet", "image": "data:image/svg+xml;base64,',
                                    Library.encode(
                                        bytes(SVG(_petState))
                                    ),
                                    '","attributes":',
                                    metadata(tokenId),
                                    "}"
                                )
                            )
                        )
                    )
                )
            );
    }
    function getSVGImage(uint256 tokenId)
    public
    view
    returns (string memory)
    {
        PetState memory petState = petState(tokenId);

        State memory _petState = State(
            petState.isAlive,
            petState.growthStage,
            petState.hatchedAt,
            petState.lastFed,
            petState.killCount,
            petState.colorOne,
            petState.colorTwo
            );

        return SVG(_petState);
    }
    }
