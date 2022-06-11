//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { IERC721Metadata } from "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

import { ILootPFPFactory } from "./interfaces/ILootPFPFactory.sol";

contract LootPFP is ERC721 {

    address immutable private _factory;

    // lootTokenId => pfpCollectionAddress
    mapping(uint256 => address) private _pfp;
    // lootTokenId => pfpCollectionTokenId
    mapping(uint256 => uint256) _pfpId;

    constructor(address factory, string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        _factory = factory;
    }

    modifier lootOwner(uint256 tokenId) {
        address _loot = ILootPFPFactory(_factory).loot();
        require(IERC721Metadata(_loot).ownerOf(tokenId) == msg.sender, "LootPFP - Sender is not the owner of the underlying Loot");
        _;
    }

    modifier usableCollection(address pfp) {
        require(bytes(ILootPFPFactory(_factory).slugForPfpCollection(pfp)).length != 0, "LootPFP - Pfp collection not set");
        _;
    }

    function setPfp(uint256 lootId, address pfp) public lootOwner(lootId) usableCollection(pfp) {
        _pfp[lootId] = pfp;
    }

    function setIdForPfp(uint256 lootId, uint256 pfpId) public lootOwner(lootId) {
        _pfpId[lootId] = pfpId;
    }

    function tokenURI(uint256 lootId) public view virtual override returns (string memory) {
        return IERC721Metadata(_pfp[lootId]).tokenURI(_pfpId[lootId]);
    }

    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address _loot = ILootPFPFactory(_factory).loot();
        return IERC721Metadata(_loot).ownerOf(tokenId);
    }

    function balanceOf(address owner) public view virtual override returns (uint256) {
        address _loot = ILootPFPFactory(_factory).loot();
        return IERC721Metadata(_loot).balanceOf(owner);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        revert();
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        revert();
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        revert();
    }

}
