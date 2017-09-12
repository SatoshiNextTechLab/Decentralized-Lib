pragma solidity^0.4.4;

import "./User.sol"  ;




contract AdminUser is User{

 address public admin;

 function AdminUser(){
   admin=msg.sender;
 }
//Constraint on Func
modifier _OnlyAdmin{
  if(admin!=msg.sender){
    throw;
  }
  else{
    _;
  }
}
 //ReSet Fine to Zero And Does Return of Book
  function collectFine(address user)_OnlyAdmin returns (bool state){
///Find a way to implement Try here
    Record[user].Title="Null";
    Record[user].issued=false;
    Record[user].fine=0;
    returning(user);

    return true;

    }


}
