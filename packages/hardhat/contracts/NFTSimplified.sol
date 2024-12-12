// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.29;

import { ERC721 } from "./ERC721-simplified.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


//! Requirements
//? Business 
// - An NFT can have:
//   - only 1 owner
//   - multiple allowed operators 
// - An owner can have several operators with full rights over its NFTs
//? Application
//* we must throw when
// - Everything related to the 0 address is consider invalid:
//   - NFT assigned to the 0 address
// - Trying accessing the NFT without being authorized (operator or owner)
// - if _tokenId is not valid
//* We must emit when:
// - a transfer of ownership occur
// - an operator is approved, reaffirmed or revoked 

//! Questions:
// So we have the owner and 1 approved address to manage the NFT

contract NFTSimplified is ERC721, Ownable {
    //? State
    // Mapping of NFT assigned to an address
    mapping(address => uint256) public ownedNFTsCount;

    // Mapping of NFT to the owner
    mapping(uint256 => address) public nftOwner;

    // Nested mapping of approved addresses for a given NFT
    //     _tokenId -> operator address -> whether or not is approved
    mapping(uint256 => mapping(address => bool)) public allowedOperators;
    //! Options
    // Having a complex data structure to hold the whole ownership 
    // struct NFTOwnership {
    //     owner: address;
    //     approvedAddress: address;

    // }
    //? or having another mapping for the approved address only
    // mapping(uint256 => address) public approvedAddress;

    //* Custom Errors
    error InvalidToken(indexed uint256 _tokenId)
    error ZeroAddress()
    error NotAuthorized(indexed address _from)


    // A nested mapping of delegated operator having the total control over all NFT of a given owner
    mapping(address => mapping(address => bool)) public delegatedOperators;
    
    // Change or reaffirm the approved address for an NFT
    function approve(address _approved, uint256 _tokenId) external payable {}

    // Count all NFTs assigned to an owner
    function balanceOf(address _owner) external view returns (address) {}

    // Enable or disable approval for a third party ("operator") to manage
    function setApprovalForAll(address _operator, bool _approved) external {}

    // Get the approved address for a single NFT
    function getApproved(uint256 _tokenId) external view returns (address) {}

    //  Query if an address is an authorized operator for another address
    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {}

    // Transfer ownership of an NFT
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {}

    // Find the owner of an NFT
    function ownerOf(uint256 _tokenId) external view returns (address) {}
}
