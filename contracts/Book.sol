pragma solidity^0.4.4;


contract Book{
  //represent current time fr future use

  uint public currTime;
  //Constructor func
  function Book(){

  }



  //Each book will have a type book as followed
  struct book{
    uint pubTime;
    bytes32 Title;
    bytes32 bID;
    bool issued;
    uint fine;
  }
//Array books will contain the book records
  book[] public books;
//This will link an user contract to book
  mapping (address=>book) public Record;
//This will link the bID to Title of Book
  mapping (bytes32=>bytes32) public Id_Title;
//Func to Issue new Book
//Limit of Book issue is ' 1 '
  function NewBook(bytes32 _Title,bytes32 _bID) returns (bool  State){
//Find a way to implement try here
    book memory NewB;

    NewB.pubTime=0;
    NewB.Title=_Title;
    NewB.bID=_bID;
    NewB.issued=false;
    NewB.fine=0;
    Id_Title[_bID]=_Title;

    books.push(NewB);
    return true;
  }
//Calc of Fine  on issued book
function calcFine(address user)returns (uint fine){

  currTime= now;
  uint daysE=(currTime - Record[user].pubTime)/(24*60*60);
  if (daysE>15){
    return (daysE-15)*2 ;
  }
  else {
    return 0;
  }


}
  //Obvi..
  //Note : It probably won't return a string instead give the transaction recipt
  // To get a String , func must be a getter

  // Never mind , Found a workaround
function returning(address user)constant returns (string state){
  uint t=calcFine(user);
  if(t==0){
      return "Done";
    }
    else{
      return "Pay the Fine";
    }
}



}


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
 function issue(address _user,bytes32 _bID) _OnlyUser returns (bool state){
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

    Record[user].issued=false;
    Record[user].fine=0;
    returning(user);

    return true;

    }


}
