//SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.7.0;


/**
 * @dev Collection of functions related to the address type
 */
//Sends address to smart contracts
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;


            bytes32 accountHash
         = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    // function sendValue(address payable recipient, uint256 amount) internal {
    //     require(address(this).balance >= amount, "Address: insufficient balance");

    //     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
    //     (bool success, ) = recipient.call({ value: amount }).("");
    //     require(success, "Address: unable to send value, recipient may have reverted");
    // }
}

//allows smart contracts to receive tokens in compliance of ERC721 standards
interface IERC721TokenReceiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
    external returns (bytes4);
}

//contains functions for non=fungible tokens
interface IERC721 {
    /**
     * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */ //mapping(address=>mapping(address=>bool)) _operator;
 
    function setApprovalForAll(address operator, bool _approved) external;


    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */

    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
      * @dev Safely transfers `tokenId` token from `from` to `to`.
      *
      * Requirements:
      *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
      * - `tokenId` token must exist and be owned by `from`.
      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
      *
      * Emits a {Transfer} event.
      */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

//implements functions specified above
contract Demo is IERC721{

  //imports content form the address library above.
  using Address for address;

  //create a mapping with the name of balances.
  mapping (address => uint256) balances;

  //create a mapping from the tokenID to address.
  mapping (uint256 => address) tokenIDToAddress;

  //create a mapping needed to approve the address
  mapping(uint256 => address) private approvingIdOfToken;

  //create a mapping for the third party (operator)
  //bool value, if true then operator is valid third party
  mapping(address => mapping(address => bool)) private operators;

  //used in _safeTransferFrom to check if the contract can receive the tokens with ERC721 standard
  bytes4 internal constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
  uint256 private nextTokenId;

  //address admin;

  constructor() public{
    //admin = msg.sender;
  }

  function mint(address _owner, uint256 _tokenId) public{
    balances[_owner]++;
    tokenIDToAddress[_tokenId] = _owner;
    emit Transfer(address(0), _owner, _tokenId);
    //nextTokenId++;
  }

  //declare function balanceOf
  function balanceOf(address _owner) external view returns (uint256){
    //returns the balance of the address of the owner (which is the address provided to the function)
    return balances[_owner];
  }

  //declare function ownerOF which returns the address of the ownder based on the tokenId
  function ownerOf(uint256 _tokenId) external view returns (address){
    //require(tokenId != )
    //returns the address of the owner
    return tokenIDToAddress[_tokenId];
  }

  function getApproved(uint256 _tokenId) external view returns (address){
    return approvingIdOfToken[_tokenId];
  }


  function safeTransferFrom(
    address _from, 
    address _to, 
    uint256 _tokenId, 
    bytes calldata data) external {
      _safeTransfer(_from, _to, _tokenId, data);
    }

  //declare funciton safeTransferFrom which 
  function safeTransferFrom(
    address _from, 
    address _to, 
    uint256 _tokenId) external {
      _safeTransfer(_from, _to, _tokenId, "");
  }

  function transferFrom(
    address _from, 
    address _to, 
    uint256 _tokenId
    ) external {
      _transfer(_from, _to, _tokenId);
    }


  function approve(
    address _approved, 
    uint256 _tokenId
    ) external {
      //check the current owner
      //only the token owner can approve
      address owner = tokenIDToAddress[_tokenId];
      require(
        msg.sender == owner,
        "ERC721Contract: This is not an Authorized Address."
      );
      approvingIdOfToken[_tokenId] = _approved;
      emit Approval(owner, _approved, _tokenId);
    }
  

  function setApprovalForAll(address _operator, bool _approved) external{
    //setting multiple approvers to operate the tokens
    operators[msg.sender][_operator] = _approved;
    emit ApprovalForAll(msg.sender, _operator, _approved);
  }

  function isApprovedForAll(
    address _owner, 
    address _operator
    ) 
    external 
    view 
    returns (bool)
    {
      return operators[_owner][_operator];
    }



  function _transfer(
    address _from,
    address _to,
    uint256 _tokenId
  ) internal allowTransfer(_tokenId){
    //changing balance based on transfer
    balances[_from] -= 1;
    balances[_to] += 2;
    // confirming that the token owner has been changed
    tokenIDToAddress[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function _safeTransfer(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory data
  ) internal {
    //transfers token
    _transfer(_from, _to, _tokenId);
    if (_to.isContract()) {
      //onERC721 function returns the byes for the hash for the values passed to it
      //stores the bytes in a variable
      bytes4 returnval = IERC721TokenReceiver(_to).onERC721Received(
        msg.sender, 
        _to, 
        _tokenId, 
        data
        );
      require(
        returnval == MAGIC_ON_ERC721_RECEIVED,
        "receipient Smart Contract cannot handle ERC Tokens"
      );
    }
  }
  modifier allowTransfer(uint256 _tokenId){
    //extract the owner address using _tokenId
    address owner = tokenIDToAddress[_tokenId];
    //msg.sender should be the owner
    //owner has to be approved owner of token
    //msg.sender must be in operators list
    require(
      owner == msg.sender ||
        approvingIdOfToken[_tokenId] == msg.sender ||
        operators[owner][msg.sender] == true,
        "ERC721Contrct: This is not the Authorized Address."
    );
    _;
  }
}

