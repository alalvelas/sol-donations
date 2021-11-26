// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";

contract DoNFT is ERC721PresetMinterPauserAutoId, Ownable {

    constructor() ERC721PresetMinterPauserAutoId('DoNFT', 'DNFT', 'https://donft/metadata/') {}

    function mintDoNFT(address _recipient) public onlyOwner {
        mint(_recipient);
    }

}