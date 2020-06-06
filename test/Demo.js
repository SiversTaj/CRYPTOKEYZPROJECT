const Demo = artifacts.require("Demo");
const { expectRevert } = require("@openzeppelin/test-helpers");
const BigNumber = require("bignumber.js");
const truffleAssert = require("truffle-assertions");
const CryptoKeyz = artifacts.require("CryptoKeyz");
const mintingAddress = "0x0000000000000000000000000000000000000000";
const BlankContract = artifacts.require("BlankContract");

contract("Demo", (accounts)=>{
    let instance;
    const [admin, trader1, trader2] = [accounts[0], accounts[1], accounts[2]];

    before(async()=>{
         instance = await Demo.deployed();
        // calls mint twice and stores value in the tx variable
        for (let i=0; i < 3; i++) {
            //who runs the mint function has the tokens
            const tx = await instance.mint(admin,i);
        }
    });

    it("test: balanceOf function", async () => {
        //knows that initial supply is 2 based on the funciton above.
        const initialTokenSupply = 3;
        //calls balance of function on the instance of the token
        //since the admin ran the mint function he owns the tokens in this instance
        console.log(admin);
        const tx = await instance.balanceOf(admin);
        console.log(tx);
        assert(
            new BigNumber(tx).isEqualTo(new BigNumber(initialTokenSupply)),
            "Value does not match the expected initial supply."
        );
    });

    it("test: ownerOf function", async () => {
        //receive addres by providing the token id
        //first token must have - token itd because the increment starts at 0
        const tokenId = 0;
        //0 token belongs to admin because he made the first 2 tokens;
        const addressExpected = admin;
        //returns token address in the form of a string.
        const tx = await instance.ownerOf.call(tokenId);
        //call assert to check
        assert(tx === addressExpected, "This is not the expected owner");
    });

    it("test: getApproved function", async () => {
        const tokenId = 0;
        const addressExpected = "0x0000000000000000000000000000000000000000";
        let tx = await instance.getApproved.call(tokenId);
        assert(tx === addressExpected, "This is not the correct approving token ID");
    });

    it("test: transferFrom() function should transfer", async () => {
        const tokenId = 0;
        //before transferfrom check the balance.
        const adminBalanceBefore = await instance.balanceOf.call(admin);
    
        const receipt = await instance.transferFrom(admin, trader1, tokenId, {
          from: admin,
        });

        const [adminBalance, trader1Balance, owner] = await Promise.all([
            //shows whether the token was transferred to the other address or not
            //should decrease from 3 - 2
            instance.balanceOf(admin),
            //should increase from 0 - 1
            instance.balanceOf(trader1),
            //gives address of NEW owner
            instance.ownerOf(tokenId),
          ]);
        console.log(adminBalanceBefore);
        console.log(trader1Balance);
        console.log(adminBalance);
          //assert(
            //checks proof of transfer
            //can check balances by console.log
            //before balance - trader balance must equal to new balance
            //new BigNumber(adminBalanceBefore)
            //  .minus(new BigNumber(adminBalance))
            //  .isEqualTo(new BigNumber(trader1Balance)),
            //"This is not expected supply"
          //);
          assert(new BigNumber(trader1Balance).isEqualTo(new BigNumber(2)))
          assert(owner === trader1, "This is not expected owner");
      
          //emit event Transfer
          truffleAssert.eventEmitted(receipt, "Transfer", (obj) => {
            return (
              obj.from === admin &&
              obj.to === trader1 &&
              new BigNumber(obj.tokenId).isEqualTo(new BigNumber(tokenId))
            );
        });
    });
    //check the call to the ERC721Receiver contract
    it("test: safeTransferFrom()", async () => {
        const tokenId = 1;
        const adminBalanceBefore = await instance.balanceOf.call(admin);
        const receipt = await instance.transferFrom(admin, trader1, tokenId, {
            from: admin,
        });

        const [adminBalance, trader1Balance, owner] = await Promise.all([
            instance.balanceOf(admin),
            instance.balanceOf(trader1),
            instance.ownerOf(tokenId),
        ]);

        assert(adminBalance.toNumber() === 1, "This is not th expected supply");
        assert(owner === trader1, "This is not the expected owner");

        //emit event Transfer
        truffleAssert.eventEmitted(receipt, "Transfer", (obj) => {
            return(
                obj.from === admin &&
                obj.to === trader1 &&
                new BigNumber(obj.tokenId).isEqualTo(new BigNumber(tokenId))
            );
        });
    });

    //check what happens if implementing ERC721Receiver
    it("safeTransferFrom should not transfer if the receiver doesn't use ERC721", async () => {
        const BadReceiver = await BlankContract.new();
        await expectRevert(
            instance.safeTransferFrom(trader1, BadReceiver.address, 0, {
                from: trader1,
            }),
            "revert"
        );
    });
    it("should transfer when apporved", async () => {
        const tokenId = 2;
        const trader1BalanceBefore = await instance.balanceOf.call(trader1);
        const receipt1 = await instance.approve(trader1, tokenId, { from: admin });
    
        const apporvedReceipt = await instance.getApproved(tokenId);
        const receipt2 = await instance.transferFrom(trader1, trader2, tokenId, {
          from: trader1,
        });
    
        const [adminBalance, trader1Balance, owner] = await Promise.all([
          instance.balanceOf(trader1),
          instance.balanceOf(trader2),
          instance.ownerOf(tokenId),
        ]);
        console.log("***********************")
        console.log(trader1Balance);
        // assert(
        //     new BigNumber(trader1BalanceBefore)
        //       .minus(new BigNumber(adminBalance))
        //       .isEqualTo(new BigNumber(trader1Balance)),
        //     "This is not expected supply"
        //   );
          assert(new BigNumber(trader1Balance).isEqualTo(new BigNumber(2)))
          assert(owner === trader2, "This is not expected owner");
      
          //emit event Transfer
          truffleAssert.eventEmitted(receipt1, "Approval", (obj) => {
            return (
              obj.owner === admin &&
              obj.approved === trader1 &&
              new BigNumber(obj.tokenId).isEqualTo(new BigNumber(tokenId))
            );
          });
        });

        it("test setApprovalForAll function", async () => {
            const receipt = await instance.setApprovalForAll(admin, true, {
              from: trader1,
            });
        
            truffleAssert.eventEmitted(receipt, "ApprovalForAll", (obj) => {
              return (
                obj.owner === trader1 &&
                obj.operator === admin &&
                obj.approved === true
              );
            });
            const receipt2 = await instance.isApprovedForAll.call(trader1, admin);
        
            assert(receipt2 === true, "This is not expected apporved output");
          });
        });


contract("CryptoKeyz", (accounts) => {
    let CryptoKeyInstance;
    const [admin, player1, player2] = [accounts[0], accounts[1], accounts[2]];
    //first pokemon created by the admin
    const firstCryptoKeyName = "Excalibur";
    const firstCryptoKeyPower = new BigNumber(1000);
  
    before(async () => {
      CryptoKeyInstance = await CryptoKeyz.deployed();
    });
  
    it("Check pre-created CryptoKey 'Excalibur'", async () => {
      const tokenId = 0;
      const receipt = await CryptoKeyInstance.cryptokey(tokenId);
  
      assert(
        receipt.name === firstCryptoKeyName,
        "This is not expected CryptoKey Name"
      );
  
      assert(
        new BigNumber(receipt.power).isEqualTo(firstCryptoKeyPower),
        "This is not expected CryptoKey Power Level."
      );
    });
  
    it("should return the right owner", async () => {
      const tokenId = 0;
      const receipt = await CryptoKeyInstance.idToOwner(tokenId);
      assert(receipt === admin);
    });
  
    it("should create a desired CryptoKey", async () => {
      const name = "Tensuyga";
      const power = 200;
      const CryptoKeyId = 1;
      const CryptoKeyReceipt = await CryptoKeyInstance.createCryptoKey(
        name,
        power,
        { from: player1 }
      );
  
      const mintedTx = await CryptoKeyInstance.mint(player1, CryptoKeyId);
      truffleAssert.eventEmitted(mintedTx, "Transfer", (obj) => {
        return (
          obj.from === mintingAddress &&
          obj.to === player1 &&
          new BigNumber(obj.tokenId).isEqualTo(new BigNumber(CryptoKeyId))
        );
      });
      assert(
        CryptoKeyReceipt,
        name,
        power,
        "This is not the expected information."
      );
      const receipt = await CryptoKeyInstance.idToOwner(CryptoKeyId);
  
      assert(receipt === player1, "This is not expected owner");
    });
  
    it("Should the return array of ids", async () => {
      let receipt = await CryptoKeyInstance.getCryptoKeyzId.call();
  
      assert(
        new BigNumber(receipt[0]).isEqualTo(new BigNumber(0)),
        "This is not expected Id: 0"
      );
      assert(
        new BigNumber(receipt[1]).isEqualTo(new BigNumber(1)),
        "This is not expected Id: 1"
      );
    });
  
    it("get the single CryptoKey using id", async () => {
      const tokendId = 1;
      let receipt = await CryptoKeyInstance.getSingleKey.call(tokendId);
  
      assert(receipt[0] === "Tensuyga", "This is not the expected name");
      assert(
        new BigNumber(receipt[1]).isEqualTo(new BigNumber(200)),
        "This is not expected CryptoKey Power"
      );
    });    
});