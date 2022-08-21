// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./IWhitelist.sol";

contract JsDevs is ERC721Enumerable, Ownable {
    /**
    * @dev _baseTokenURI for computing {tokenURI}. If set, the resulting URI for each
    * token will be the concatenation of the `baseURI` and the `tokenId`.
    */

    string _baseTokenURI;
    uint public price = 0.05 ether;

    // _paused is used to pause the contract in case of an emergency
    bool public _paused;

    // max number of Js Devs NFTs
    uint public maxTokenIds = 20;

    // total number of minted tokenIds
    uint public mintedTokenIds;

    // whitelist contract instance
    IWhitelist whitelist;

    // keeping track if presale has started or not
    bool public presaleStarted;

    // when presale would end
    uint public presaleEnded;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract is currently paused!!");
        _;
    }

    constructor(string memory baseURI, address whitelistContract) ERC721("JS Devs", "JSD") {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    function startPresale() public onlyOwner {
        presaleStarted = true;
        // Set presaleEnded time as current timestamp + 5 minutes
        presaleEnded = block.timestamp + 5 minutes;
    }

    function presaleMint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp < presaleEnded, "Presale has not started!!");

        require(whitelist.whitelistedAddresses(msg.sender), "You are not whitelisted!!");

        require(mintedTokenIds < maxTokenIds, "Exceeded maximum JS Devs supply!!");

        require(msg.value >= price, "Ether sent is not enough!!");

        mintedTokenIds += 1;
        _safeMint(msg.sender, mintedTokenIds);
    }

    /**
      * @dev mint allows a user to mint 1 NFT per transaction after the presale has ended.
      */
    function mint() public payable onlyWhenNotPaused {
        require(presaleStarted && block.timestamp >=  presaleEnded, "Presale has not ended yet");
        require(mintedTokenIds < maxTokenIds, "Exceed maximum JS Devs supply!!");
        require(msg.value >= price, "Ether sent is not enough");
        mintedTokenIds += 1;
        _safeMint(msg.sender, mintedTokenIds);
    }

    /**
    * @dev _baseURI overides the Openzeppelin's ERC721 implementation which by default
    * returned an empty string for the baseURI
    */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    function withdraw () public onlyOwner {
        address _owner = owner();
        uint amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to withdraw funds!!");
    }

    receive() external payable {}
    fallback() external payable {}
}

