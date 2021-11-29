// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";

contract DoNFT is ERC721 {
    using Counters for Counters.Counter;

    Counters.Counter nftCount;

    constructor() ERC721('DoNFT', 'DNFT') {}

    function mintDoNFT(address _recipient) internal {
        nftCount.increment();
        uint256 id = nftCount.current();

        _safeMint(_recipient, id);
    }

}