pragma solidity ^0.8.0;

import { ILootPFPFactory } from "./interfaces/ILootPFPFactory.sol";

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { LootPFP } from "./LootPFP.sol";

contract LootPFPFactory is Ownable {

    address private _loot;

    string[] private _allLootCollectionsSlug;
    string[] private _allWhitelistedPfpsCollectionsSlug;

    // slug => lootAddress (e.g. Loot or GenesisLoot)
    mapping(string => address) private _lootverseCollections;

    // slug => pfpAddress (e.g. HyperLoot)
    mapping(string => address) private _usablePfpsCollections;
    // pfpAddress => slug
    mapping(address => string) private _slugForPfpCollection;

    // lootverseCollection (e.g. Loot or GenesisLoot) => LootPFP 
    mapping(address => address) private _lootPfpsContracts;

    constructor(address loot_) {
        _loot = loot_;
    } 

    ///////////
    // GETTERS
    function getAllLootverseCollectionsSlugs() public view returns(string[] memory) {
        return(_allLootCollectionsSlug);
    }   

    function getAllWhitelistedPfpsCollectionsSlug() public view returns(string[] memory) {
        return(_allWhitelistedPfpsCollectionsSlug);
    } 

    function getLootverseCollection(string calldata slug) public view returns(address) {
        return _lootverseCollections[slug];
    }

    function getPfpCollection(string calldata slug) public view returns(address) {
        return _usablePfpsCollections[slug];
    }

    function getLootversePfpContract(address lootCollection) public view returns(address) {
        return _lootPfpsContracts[lootCollection];
    }

    function getLootversePfpFromSlug(string calldata slug) public view returns(address) {
        address lootCollection = getLootverseCollection(slug);
        return _lootPfpsContracts[lootCollection];
    }

    function slugForCollection(address pfp) public view returns(string memory) {
        return _slugForPfpCollection[pfp];
    }

    function loot() public view returns(address) {
        return _loot;
    }
    
    ///////////
    // SETTERS
    function addPfpCollection(string calldata slug, address pfpCollection) onlyOwner public {
        require(_usablePfpsCollections[slug] == address(0), "LootPFPFactory::addPfpCollection - PFP collection already set");
        _allWhitelistedPfpsCollectionsSlug.push(slug);
        _slugForPfpCollection[pfpCollection] = slug;
        _usablePfpsCollections[slug] = pfpCollection;
    }

    function modifyPfpCollection(string calldata slug, address pfpCollection) onlyOwner public {
        require(_usablePfpsCollections[slug] != address(0), "LootPFPFactory::addPfpCollection - PFP collection non existant");
        _usablePfpsCollections[slug] = pfpCollection;
    }

    function addLootverseCollection(string calldata slug, string calldata symbol, address lootCollection) onlyOwner public {
        require(_lootverseCollections[slug] == address(0), "LootPFPFactory::addLootCollection - PFP collection already set");
        _allLootCollectionsSlug.push(slug);
        _lootverseCollections[slug] = lootCollection;
        // create new pfp contract from factory
        LootPFP lootPfpContract = new LootPFP(address(this), slug, symbol);
        // add new contract address to _lootPfpsCollections
        _lootPfpsContracts[lootCollection] = address(lootPfpContract);
    }

    function modifyLootverseCollection(string calldata slug, address lootCollection) onlyOwner public {
        require(_lootverseCollections[slug] != address(0), "LootPFPFactory::addLootCollection - Loot collection non existant");
        _lootverseCollections[slug] = lootCollection;
    }

    function setLoot(address newLoot) onlyOwner public {
        _loot = newLoot;
    }

}