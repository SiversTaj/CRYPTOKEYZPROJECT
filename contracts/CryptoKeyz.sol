//SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.7.0;
import "./Demo.sol";


contract CryptoKeyz is Demo{
  address admin;
  uint256 CryptoKeyId;

  struct CryptoKey{
    uint256 id;
    string name;
    uint256 power;
  }

  uint256 [] ID;
  //EVERY TOKEN LINKED TO AN ADDRESS
  mapping(uint256 => CryptoKey ) public cryptokey;
  //EVERY TOKEN ID LINKED TO AN OWNER
  //SHOWS THAT EACH CRYPTOKEY IS LINKED TO A SPECIFIC OWNER
  mapping(uint256 => address) public idToOwner;

  constructor() public {
    admin = msg.sender;
    //CREATE FIRST CRYPTOKEY
    CryptoKey memory crypto = CryptoKey(CryptoKeyId, "Excalibur", 1000);
    cryptokey[CryptoKeyId] = crypto;
    ID.push(CryptoKeyId);
    //CREATING TOKENS
    mint(admin, CryptoKeyId);
    idToOwner[CryptoKeyId] = admin;
    CryptoKeyId++;
  }
  //function to create CryptoKey
  function createCryptoKey(
    string calldata _name,
    uint256 _power
  ) external {
    require(_power < 1000, "CryptoKey: The power level should be less than 1000");
    //EVERYTIME A CRYPTOKEY IS CREATED IT HAS THESE ATTRIBUTES
    cryptokey[CryptoKeyId] = CryptoKey(CryptoKeyId, _name, _power);

    ID.push(CryptoKeyId);
    mint(msg.sender, CryptoKeyId);
    idToOwner[CryptoKeyId] = msg.sender;
    CryptoKeyId++;
  }
  
  function sendCryptoKey(uint256 _tokenId, address _to) external {
    //check that the user is sending his own cryptokey
    address pastOwner = idToOwner[_tokenId];
    require(msg.sender == pastOwner, "Not Authorized to send this CryptoKey ");
    _safeTransfer(pastOwner, _to, _tokenId, "");
  }

  function getCryptoKeyzId() public view returns (uint256 [] memory)  {
    return ID;
  }

  function getSingleKey(uint256 cryptoKeyId)
  public 
  view 
  returns(
    string memory,
    uint256
  )
  {
    return(
      cryptokey[cryptoKeyId].name,
      cryptokey[cryptoKeyId].power
    );
  }
}
