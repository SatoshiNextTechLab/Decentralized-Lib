pragma solidity ^0.4.4;

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
