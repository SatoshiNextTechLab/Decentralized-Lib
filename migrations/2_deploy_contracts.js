var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");
var AdminUser = artifacts.require("./AdminUser.sol");
var Book = artifacts.require("./Book.sol");
var User = artifacts.require("./User.sol");
module.exports = function(deployer) {
//  deployer.deploy(ConvertLib);
  //deployer.link(ConvertLib, MetaCoin);
  //deployer.deploy(MetaCoin);

  deployer.deploy(AdminUser);
  deployer.deploy(Book);
  deployer.deploy(User);
};
