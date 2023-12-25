// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GuviToken {
    //name of the token
    string public name = "GUVI";
    //symbol of the token
    string public symbol = "GUV";
    //decimals for the token
    uint8 public decimals = 16;
    //total supply for the token
    uint256 public totalSupply = 1900000000 * (10**uint256(decimals));

    /* Create a table so that we can map addresses
    to the balances associated with them */
    mapping(address => uint256) public balanceOf;

    /* Create a table so that we can map the addresses of contract owners to
    those who are allowed to utilize the owner's contract */
    mapping(address => mapping(address => uint256)) public allowances;

    // Owner of this contract
    address public owner;

    //this event is emitted whenever token is transferred to an another account
    event Transfer(address indexed from, address indexed to, uint256 value);
    // this event is emitted from approve function
    event Approval(address indexed owner, address indexed spender, uint256 value);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    //this event is emitted from internal function _burn
    event Burn(address indexed burner, uint256 value);
    //this event is emitted from internal function _mint
    event Mint(address indexed to, uint256 value);

    //setting modifier for customize the behaviour function
    //Here restricting to owner only can access some functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    // when code is deployed, set the owner address and balance 
    constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    //this function is called externally
    function transfer(address to, uint256 value) external returns (bool) {
        //_transfer is an internal function which will be called 
        _transfer(msg.sender, to, value);
        return true;
    }
    
    /* this function is called externally
    Here spender sends token to receiver on behalf of owner
    */
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        //checks the allowance(amount) of spender that is approved by owner
        require(value <= allowances[from][msg.sender], "Insufficient allowance");
        //decreasing allowance value from spender address
        allowances[from][msg.sender] -= value;
        //calling internal function _transfer
        _transfer(from, to, value);
        return true;
    }
    
    /* sets the allowance(value) to the spender by owner
    This emits the event called approval
    */
    function approve(address spender, uint256 value) external returns (bool) {
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    /*
    this function returns the available allowance of spender
    */
    function allowance(address _owner, address _spender) public view returns(uint256 remaining){
        return allowances[_owner][_spender];
    }
    /*
    This function is only accessible by owner
    It burns the token from owner(caller)
    */
    function burn(uint256 value) external onlyOwner {
        _burn(msg.sender, value);
    }
    /*
    This function can only be accessed by owner
    Destroying amount(allowance) from spender
    */
    function burnFrom(address from, uint256 value) external onlyOwner {
        //checking if enough amount to burn from spender 
        require(value <= allowances[from][msg.sender], "Insufficient allowance for burning");
        allowances[from][msg.sender] -= value;
        //calling the internal _burn function
        _burn(from, value);
    }
    /*
    Only owner can mint new token. But owner should have MinterRole
    */
    function mint(address to, uint256 value) external onlyOwner {
        _mint(to, value);
    }
    /*
    this function is to transfer ownership to another address
    It is only accessible by owner
    */
    function transferOwnership(address newOwner) external onlyOwner {
        //checking newOwner address is not zero address
        require(newOwner != address(0), "Invalid new owner address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
    // this function is called internally from other functions
    function _transfer(address from, address to, uint256 value) internal {
        //checking receiver address is zero address
        require(to != address(0), "Transfer to the zero address");
        //checking balance of sender
        require(value <= balanceOf[from], "Insufficient balance");
        /* changing the state 
        deducting balance from sender address
        and adding balance to receiver address */
        balanceOf[from] -= value;
        balanceOf[to] += value;
        //now Transfer event is being emitted
        emit Transfer(from, to, value);
    }
    //this internal function burns of mentioned value from caller(owner)
    function _burn(address burner, uint256 value) internal {
        //checking value is to be burned sufficient
        require(value <= balanceOf[burner], "Insufficient balance for burning");
        //decreasing value from caller(owner)
        balanceOf[burner] -= value;
        //decreasing value of total supply
        totalSupply -= value;

        emit Burn(burner, value);
        // Emitting transfer event as token is transfered to zero address from caller(owner)
        emit Transfer(burner, address(0), value);
    }
    /*
    this function Creates amount tokens and assigns them to account, 
    increasing the total supply.
    Emits a transfer event with from set to the zero address.
    */
    function _mint(address to, uint256 value) internal {
        //checking receiver address is not zero address
        require(to != address(0), "Mint to the zero address");
        //increasing total supply
        totalSupply += value;
        //increasing value of token for receiver(to) address
        balanceOf[to] += value;
        emit Mint(to, value);
        //emitting transfer event as transfering token to receiver address from zero address
        emit Transfer(address(0), to, value);
    }
    /*
    This function is to increase the allowance for the spender
    */
    function increaseAllowance(address _spender, uint256 _value) public returns (bool success){
        //checking if spender address is zero address
        require(_spender != address(0), "Invalid address");
        //checking value of token is greater than 0
        require(_value >0, "Invalid amount");
        //checking if balance of sender is sufficient
        require(balanceOf[msg.sender]>=_value, "Insufficient amount");
        //calling internal function _increaseAllowance
        _increaseAllowance(_spender,_value);
        return true;

    }

    function _increaseAllowance(address _spender, uint256 _value) internal{
        //increasing allowance to spender address
        allowances[msg.sender][_spender] += _value;
        //emiting Approval event as sender assigning/increasing allowance to spender
        emit Approval(msg.sender, _spender, _value);
    }
    
    /*
    this function is to decrease the allowance of spender
    */
    function decreaseAllowance(address _spender, uint256 _value)public returns(bool success){
        //checking if spender address is zero address
        require(_spender != address(0), "Invalid address");
        //checking value of token is greater than 0
        require(_value >0, "Invalid amount");
        //checking if allowance of spender is sufficient to decrease
        require(allowances[msg.sender][_spender]>=_value, "Insufficent allowance to decrease");
        _decreaseAllowance(_spender,_value);
        return true;
    }

    function _decreaseAllowance(address _spender, uint256 _value)internal{
        //decreasing allowance of spender
        allowances[msg.sender][_spender] -= _value;
        //emiting the Approval event as sender decreasing allowance
        emit Approval(msg.sender, _spender, _value);

    }
}
