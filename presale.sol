// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Bu kontrat, bir ERC20 tokeni oluşturur ve önsatışları yönetir.
contract Launchpad {
    Token public token;  // Oluşturulan token
    address payable public admin;  // Admin adresi
    uint256 public end;  // Önsatışın sona ereceği zaman
    uint256 public price;  // Token başına fiyat (wei cinsinden)
    mapping(address => uint256) public balanceOf;  // Adrese göre token bakiyesi
    mapping(address => uint256) public availableTokensFor;  // Adrese göre satın alınabilecek token miktarı

    // Kontrat oluşturulduğunda çalışır. İlk tokeni oluşturur ve admini belirler.
    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint256 initialSupply
    ) {
        token = new Token(tokenName, tokenSymbol, initialSupply);
        admin = payable(msg.sender);
    }

    // Adminin belirli bir fiyat, yüzde ve süreyle bir önsatış başlatmasını sağlar.
    function startPresale(uint256 _price, uint256 percentage, uint256 duration) public {
        require(msg.sender == admin, "Sadece admin onsatis baslatabilir");
        require(percentage > 0 && percentage <= 100, "Yuzde 1 ile 100 arasinda olmalidir");

        price = _price;
        end = block.timestamp + duration;
        availableTokensFor[msg.sender] = token.totalSupply() * percentage / 100;
    }

    // Kullanıcıların önsatışta token satın almasını sağlar.
    function buyTokens() public payable {
        require(block.timestamp < end, "Onsatis sona erdi");
        require(availableTokensFor[msg.sender] > 0, "Daha fazla token satista degil");
        
        uint256 tokensAmount = msg.value / price;
        require(tokensAmount <= availableTokensFor[msg.sender], "satista yeterli token yok");
        
        balanceOf[msg.sender] += tokensAmount;
        availableTokensFor[msg.sender] -= tokensAmount;
        admin.transfer(msg.value);
    }

    // Kullanıcıların önsatış sonrası tokenlarını talep etmesini sağlar.
    function claimTokens() public {
        require(block.timestamp >= end, "onsatis henuz sona ermedi");
        uint256 amount = balanceOf[msg.sender];
        require(amount > 0, "Talep edilecek token yok");
        balanceOf[msg.sender] = 0;
        token.transfer(msg.sender, amount);
    }
}

// ERC20 tokeni oluşturan kontrat.
contract Token is ERC20 {
    constructor (
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }
}
