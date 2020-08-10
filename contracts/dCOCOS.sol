pragma solidity ^0.5.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol';

/// @title dCocosToken Contract
/// For more information about this token please visit https://dcocos.finance
/// @author reedhong



contract dCOCOS is ERC20, ERC20Detailed {  
  
  address public governance;
  mapping (address => bool) public minters;

  constructor () public ERC20Detailed("dcocos.finance", "dCOCOS", 18) {
      governance = tx.origin;
  }

  function mint(address account, uint256 amount) public {
      require(minters[msg.sender], "!minter");
      _mint(account, amount);
  }
  
  function setGovernance(address _governance) public {
      require(msg.sender == governance, "!governance");
      governance = _governance;
  }
  
  function addMinter(address _minter) public {
      require(msg.sender == governance, "!governance");
      minters[_minter] = true;
  }
  
  function removeMinter(address _minter) public {
      require(msg.sender == governance, "!governance");
      minters[_minter] = false;
  }
}