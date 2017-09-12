pragma solidity ^0.4.4;

import "./Book.sol"  ;

contract User is Book{

   address public UserA;
//So the idea is to make a datatype to store user datatype
//an Array of user , Mapping address to user
  struct user{
    bytes32 name;
    uint ID;
    address usr;
  }

  mapping(address=>user) public  Usr_List;
  user[] public users;

//COnstructor OF User
function User(){
  UserA=msg.sender;
}
//Constraint on Functions
modifier _OnlyUser{
  if(UserA!=msg.sender){
    throw;
  }
  else{
    _;
  }
}

  //Check for errors
  //_ID is unique id of members and usr is their contract address
  function NewUser(bytes32 _name,uint _ID,address usr)returns (bool state){

    // Find way to implement try here

    user memory nUser;

    nUser.name= _name;
    nUser.ID=_ID;

    Usr_List[usr]=nUser;

    users.push(nUser);

    return true;
 }

//End the User data
 function kill(){
   suicide(msg.sender);
 }



   //Obvi Func
 function issue(address _user,bytes32 _bID) returns (bool state){
   Record[_user]=book({
     pubTime : now,
     Title: Id_Title[_bID],
     bID: _bID,
     issued: true,
     fine:calcFine(_user)
     });
return true;
   }


//Give's Name of Book and Fine Pending
 function getInfo(address usr) constant returns (bytes32 Name,uint fine){
   return(Record[usr].Title,calcFine(usr));
 }


}
