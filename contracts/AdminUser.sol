pragma solidity^0.4.4;

contract RickLib {

 address public admin;

 function RickLib(){
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
function bal() constant returns (uint){
    return admin.balance;
}


}

contract Book {
  //represent current time fr future use
address owner;
  uint public currTime;
  //Constructor func
  function Book(){
    owner=msg.sender;

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
  mapping (address=>bytes32) public Record;
//This will link the bID to Title of Book
  mapping (bytes32=>book) public Id_book;
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
    Id_book[_bID]=NewB;

    books.push(NewB);
    return true;
  }
//Calc of Fine  on issued book
function calcFine(address user)returns (uint fine){

  currTime= now;
  uint daysE=(currTime - Id_book[Record[user]].pubTime)/(24*60*60);
  if (daysE>15){
    return (daysE-15)*2 ;
  }
  else {
    return 0;
  }


}

function AllAvaiBooks()constant returns(bytes32[] ){

  uint length=books.length;
bytes32[] memory book_names=new bytes32[](length);
uint l =0;
  for(uint i=0;i<length;i++){

    if(!Id_book[books[i].bID].issued){


    book_names[l]=books[i].Title;

    l+=1;

  }

  }
  return book_names;
}


}


contract User is Book,RickLib{

   address public UserA;
//So the idea is to make a datatype to store user datatype
//an Array of user , Mapping address to user
  struct user{
    bytes32 name;
    uint ID;
    address usr;
    uint credits;
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
  function NewUser(bytes32 _name,uint _ID,address usr) payable returns (bool state){

    // Find way to implement try here

    user memory nUser;

    nUser.name= _name;
    nUser.ID=_ID;
    nUser.credits=msg.sender.balance;

    Usr_List[usr]=nUser;

    users.push(nUser);

    return true;

  }
//End the User data
 function kill(){
   suicide(msg.sender);
 }


//SomeOne PLease Fix this
/*
function allUsers()constant returns(address[]){

  uint len=users.length;
address[] memory Unames=new address[](len);
  for(uint i=0;i<len;i++)
  Unames[i]=users[i].usr;

  return Unames;


}
*/

   //Obvi Func
 function issue(address _user,bytes32 _bID) payable  returns (bool state){
   if(Id_book[Record[_user]].issued){
     throw;
   }
   else{
     //Someone Please Fix this

     /* if(finder(_bID))
     {
       throw;
       return false;

     }
     else{}*/
   /*Record[_user]=book({
     pubTime : now,
     Title: Id_Title[_bID],
     bID: _bID,
     issued: true,
     fine:calcFine(_user)
*/
Record[_user]=_bID;
Id_book[_bID].pubTime=now;
Id_book[_bID].issued=true;
Id_book[_bID].fine=calcFine(_user);


  Usr_List[_user].credits=Usr_List[_user].credits-1;

return true;

}
   }

//SomeOne Please Fix This
/*   function  finder(bytes32 _bID) constant returns (bool st){
for(uint i=0;i<users.length;i++){
    if(Record[users[i].usr].bID == _bID){
      return true;

    }
  }
  return false;
   }

*/

//Obvi..
//Note : It probably won't return a string instead give the transaction recipt
// To get a String , func must be a getter

// Never mind , Found a workaround
function returning(address _User,bytes32 _bID)payable returns (bool){
uint t=calcFine(_User);
if(t==0){
    return true;
    Id_book[_bID].issued=false;
    Id_book[_bID].fine=0;
  }
  else{
      if(Id_book[_bID].issued ) {
   admin.send(t);

  Id_book[_bID].issued=false;
  Id_book[_bID].fine=0;
  Id_book[_bID].pubTime=now;
    return true;
  }
}
}

//Give's Name of Book , Fine Pending , Credits
 function getInfo(address usr) constant returns (bytes32 Name,uint fine,uint _credits){
   return(Id_book[Record[usr]].Title,calcFine(usr),Usr_List[usr].credits);
 }


}
