pragma solidity 0.5.15;
import "./SafeMath.sol";

contract PODAContract {
  using SafeMath for uint256;

  event MemberRegistered(address member, address referrer);
  event BetPlaced(address sender, uint amount);
  event VoteCasted(address sender, uint amount);
  event Withdrawal(address owner, uint amount);

  address public admin;
  mapping (address => Member) Members;
  address[] memberList; 

  struct Member {
    address referrer;        
    bool isFounder;       
    bool isRegistered;
  }
  
  constructor() public {
    admin = msg.sender;

    // create the first user that will refer subsequent users
    Members[msg.sender].isRegistered = true;
    memberList.push(msg.sender);
    emit MemberRegistered(msg.sender, address(0));
  } 

  modifier isAdmin() {
    require(msg.sender == admin, "admin_only");
    _;
  }
  
  function close() public isAdmin {
    selfdestruct(msg.sender);
  }

  function sum(uint[] memory _amounts) private pure returns (uint retVal) {
    uint total = 0;
    for (uint i=0; i < _amounts.length; i++) {
      total = total.add(_amounts[i]);
    }
    return total;
  }

  function withdraw(address payable[] memory _addresses, uint[] memory _amounts) public isAdmin returns (uint)  {
    require(_addresses.length == _amounts.length, "address_amount_length_not_same");
    
    uint total = sum(_amounts);
    uint contractBalance = address(this).balance;
    require(contractBalance >= total, "total_greater_than_balance");
    
    for (uint i=0; i < _addresses.length; i++) {
      address payable owner = _addresses[i];

      (bool success, ) = owner.call.value(_amounts[i])("");
      require(success, "transfer_failed");
      emit Withdrawal(owner, _amounts[i]);
    }
  }

  // == START USER FUNCTIONS ==
  function registerNewUserNoReferrer() public {
    // if the referrer wasn't provided, 
    // set the first user as the default referrer
    registerNewUser(admin);
  }
  
  function registerNewUser(address _referrer) public {
    require(!Members[msg.sender].isRegistered, "sender_registered");
    require(Members[_referrer].isRegistered, "referrer_not_registered");
    require(_referrer!=msg.sender, "sender_same_referrer");
    
    Members[msg.sender].referrer = _referrer;
    Members[msg.sender].isRegistered = true;
    memberList.push(msg.sender); 
    emit MemberRegistered(msg.sender, _referrer);
  }

  function isRegistered(address _address) public view returns (bool) {
    return Members[_address].isRegistered;
  }

  function getReferrer(address _address) public view returns (address) {
    return Members[_address].referrer;
  }

  // == END USER FUNCTIONS ==
  
  // == START BET FUNCTIONS ==

  function placeBet() payable public returns (bool) {
    require(msg.value > 0, "amount_zero");
    emit BetPlaced(msg.sender, msg.value);
    
    return true;
  }
  // == END BET FUNCTIONS == 
  
  // == START VOTE FUNCTIONS ==
  function placeVote() payable public returns (bool) {
    require(msg.value > 0, "amount_zero");
    emit VoteCasted(msg.sender, msg.value);

    return true;
  }
  // == END VOTE FUNCTIONS ==
}