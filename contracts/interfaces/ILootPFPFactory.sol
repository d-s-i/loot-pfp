pragma solidity ^0.8.0;


interface ILootPFPFactory {

    ///////////
    // GETTERS
    function getAllLootverseCollectionsSlugs() external view returns(string[] memory);
    function getAllWhitelistedPfpsCollectionsSlug() external view returns(string[] memory);
    function getLootverseCollection(string calldata slug) external view returns(address);
    function getPfpCollection(string calldata slug) external view returns(address);
    function getLootversePfpContract(address lootCollection) external view returns(address);
    function getLootversePfpFromSlug(string calldata slug) external view returns(address);
    function slugForCollection(address pfp) external view returns(string memory);
    function loot() external view returns(address);
    
    ///////////
    // SETTERS
    function addPfpCollection(string calldata slug, address pfpCollection) external;
    function modifyPfpCollection(string calldata slug, address pfpCollection) external;
    function addLootverseCollection(string calldata slug, string calldata symbol, address lootCollection) external;
    function modifyLootverseCollection(string calldata slug, address lootCollection) external;

}