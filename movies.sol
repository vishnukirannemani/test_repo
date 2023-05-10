// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MovieToken is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter public tokenIds;


    struct Movie {
        string MovieName;
        uint256 MovieID;
        uint256 price;
        string ProductionCompany;
        uint256 ProductionID;
        uint min;
        uint max;
        uint base;
        uint apprcPercent;
        uint deprcPercent;
        
    }
    address public Admin;
    address payable public accountOwner;
    uint256 public totalMoviesMinted;
    mapping(uint256 => Movie) public MovieMap;

    constructor() ERC721("Movienizatation","MVTK"){
        
        Admin = msg.sender;
    }

    function MovieTokenize(string memory MovieName, uint256 price, string memory ProductionCompany, uint256 ProductionID, uint256 min, uint256 max, uint256 base, uint apprcPercent, uint deprcPercent) public {
        require(msg.sender != address(0));
        require(price > 0, "Price cannot be 0 or less than 0");
        require(min > 14, "Digital Content cannot be posted prior to 2 weeks");
        require(base > min && base < max, "Base should be in between min and max");
        tokenIds.increment();
        uint256 TokenId = tokenIds.current();
        _safeMint(msg.sender, TokenId);
        MovieMap[TokenId] = Movie(MovieName, TokenId, price, ProductionCompany, ProductionID);
        totalMoviesMinted += 1;
    }

    function MovieDetails(uint256 tokenId) public view returns (Movie memory) {
        require(_exists(tokenId), "token does not exist");
        return MovieMap[tokenId];
    }

    

    function buyMVTK(uint256 tokenId, uint256 Days) public payable {
        require(_exists(tokenId), "tokenId does not exist");
        require(msg.sender != ownerOf(tokenId), "Invalid transaction");
        require(msg.value == MovieMap[tokenId].price, "token price not matched");
        require(Days > 20, "Digital content cannot be posted before 20 days");
        MovieMap[tokenId].min
        if(Days > 20 && Days < 30){
            pay = MovieMap[tokenId].price + (1/2*MovieMap[tokenId].price);
        }
        else if(Days > 30 && Days < 40){
            pay = MovieMap[tokenId].price + (1/4*MovieMap[tokenId].price);
        }
        else if(Days > 40 && Days < 50){
            pay = MovieMap[tokenId].price + (1/10*MovieMap[tokenId].price);
        }
        else if(Days == 50){
            pay = MovieMap[tokenId].price;
        }
        else if(Days > 50 && Days < 70){
            pay = MovieMap[tokenId].price - (1/10*MovieMap[tokenId].price);
        }
        else if(Days > 70 && Days < 100){
            pay = MovieMap[tokenId].price - (1/4*MovieMap[tokenId].price);
        }
        else if(Days > 100){
            pay = MovieMap[tokenId].price - (1/2*MovieMap[tokenId].price);
        }
        accountOwner = payable(msg.sender);
        _transfer(ownerOf(tokenId), msg.sender, tokenId);
        accountOwner.transfer(msg.value);
    }

    function appreciation(uint256 tokenId, uint valAdd) public{
        require(msg.sender == ownerOf(tokenId), "Not the owner of the token"); 
        MovieMap[tokenId].price = MovieMap[tokenId].price + valAdd;
        }

    function depriciation(uint256 tokenId, uint valSub) public{
        require(msg.sender == ownerOf(tokenId), "Not the owner of the token"); 
        MovieMap[tokenId].price = MovieMap[tokenId].price - valSub;
        }

}

###
#####
