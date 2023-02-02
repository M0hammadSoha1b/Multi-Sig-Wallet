// SPDX-License-Identifier: MIT
pragma solidity 0.8.6;

contract Multisig{
   
   uint limit;

   mapping(address => mapping(uint => bool))private approvals ;
   mapping( address => bool ) public owners;

   event TansferRequest(uint _id , uint _amount , address _caller , address _recipent);
   event ApprovalRecieved(uint _id , uint _approvals ,address _caller);
   event TransferApproved(uint _id);

   constructor( address add1 , address add2 , address add3, uint _limit ){
    limit = _limit;
   owners[add1] = true;
   owners[add2] = true;
   owners[add3] = true;
   }

   struct Transfer {
       uint amount;
       address payable recipent;
       uint approvals;
       bool hasBeenSent;
       uint id;
   }

   Transfer[] transferRequest;

   function transfer(uint _amount , address payable _recipent) public {
       require (owners[msg.sender] , "You ar not the owner");
       emit TansferRequest(transferRequest.length , _amount , msg.sender , _recipent);
       transferRequest.push(Transfer(_amount , _recipent , 0 , false , transferRequest.length));
   }

   function deposite() public payable {}

   function approve(uint _id) public  {
      require (owners[msg.sender] , "You ar not the owner");
      require(transferRequest[_id].hasBeenSent == false);
      require(approvals[msg.sender][_id] == false , "You have already voted ");
      approvals[msg.sender][_id] = true;
      transferRequest[_id].approvals++;
      emit ApprovalRecieved(_id,  transferRequest[_id].approvals, msg.sender);
      if(transferRequest[_id].approvals >= limit){
          transferRequest[_id].hasBeenSent = true ;
          transferRequest[_id].recipent.transfer(transferRequest[_id].amount);
          emit TransferApproved( _id);
     }

   }

   function getTransferRequest() public view returns(Transfer[] memory){
       return transferRequest;
   }

   function getBalance() public view returns(uint){
       return address (this).balance;
   }
}

//owners ["0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2" ,"0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db","0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB"]


