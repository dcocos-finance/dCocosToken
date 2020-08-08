/// @title CocosGateway
/// swap COCOS<->dCOCOS 1:1 
/// For more information about this token please visit https://dcocos.finance
/// @author reedhong
pragma solidity ^0.5.0;


import '@openzeppelin/contracts/ownership/Ownable.sol';
import './IERC20.sol';
import './SafeERC20.sol';

contract CocosGateway is Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    IERC20 public cocos = IERC20(0x60626db611a9957C1ae4Ac5b7eDE69e24A3B76c5);
    IERC20 public dcocos = IERC20(0x16cAC1403377978644e78769Daa49d8f6B6CF565);


    uint256 public dcocosTotalSupply = 0;
    uint256 public dcocosMaxSupply = 2400000000*1e18;

    event MintDCOCOS(uint256 amount);
    event SwapDCOCOS(address indexed user, uint256 amount);
    event SwapCOCOS(address indexed user, uint256 amount);


    function addDCOCOSSupply(uint256 supply) 
        public
        onlyOwner
    {
        dcocosMaxSupply = dcocosMaxSupply.add(supply);
    }

    function _mintDCOCOS(uint256 amount) internal{
        uint256 supply = dcocosTotalSupply.add(amount);
        require(supply < dcocosMaxSupply, "supply is too large");
        dcocos.mint(address(this),amount);
        emit MintDCOCOS(amount);
    }

    // COCOS->dCOCOS
    function swapDCOCOS(uint256 amount) 
        public
        returns (bool) 
    {
        uint256 dcocosBalance =  dcocos.balanceOf(address(this));
        if( dcocosBalance < amount){
            _mintDCOCOS(amount.sub(dcocosBalance));
        }

        cocos.safeTransferFrom(msg.sender, address(this), amount);
        dcocos.safeTransfer(msg.sender, amount);

        emit SwapDCOCOS(msg.sender, amount);

        return true;
    }


    // dCOCOS->COCOS
    function swapCOCOS(uint256 amount) 
        public
        returns (bool) 
    {
        uint256 cocosBalance =  cocos.balanceOf(address(this));
        require(cocosBalance >= amount, "amount is too large");

        dcocos.safeTransferFrom(msg.sender, address(this), amount);
        
        cocos.safeTransfer(msg.sender, amount);
        emit SwapCOCOS(msg.sender, amount);

        return true;
    }

}