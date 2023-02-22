//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Exchange is ERC20 
{
    address public cryptoDevTokenAddress;
    constructor (address _CryptoDevToken) ERC20("CryptoDev LP Token", "CDLP")
    {
        require (_CryptoDevToken != address(0), "Token address passed is a null address");
        cryptoDevTokenAddress = _CryptoDevToken;
    }
    function getReserve() public view returns (uint) {
        return ERC20(cryptoDevTokenAddress).balanceOf(address(this));
    }
    function addLiquidity(uint _amount) public payable returns(uint)
    {
        uint liquidity;
        uint ethBalance = address(this).balance;
        uint cryptoDevTokenReserve = getReserve();
        ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);

        if(cryptoDevTokenAddress == 0) 
        {
            cryptoDevToken.transferFrom(msg.sender, address(this), _amount)
            liquidity = ethBalance;
            _mint(msg.sender,liquidity);
        }
        else {
            uint ethReserve = ethBalance - msg.value;
            uint cryptoDevTokenAmount = (msg.value * cryptoDevTokenReserve)/(ethBalance);
            require(amount>= cryptoDevTokenAmount, "Amount Of Token Sent is less than require");
            cryptoDevToken.transferFrom(msg.sender,address(this), cryptoDevTokenAmount);
        }

    }
}
