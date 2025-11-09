// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FIXTrust is ERC20, ERC20Permit, Ownable, ERC165 {
    uint256 private constant TOTAL_SUPPLY = 100_000_000 * 10**18;

    constructor(
        address treasury,
        address lpWallet,
        address publicSale
    ) ERC20("FIXTrust", "FIXT") ERC20Permit("FIXTrust") Ownable(msg.sender) {
        require(treasury != address(0), "Treasury zero");
        require(lpWallet != address(0), "LP zero");
        require(publicSale != address(0), "Sale zero");

        _mint(treasury,   20_000_000 * 10**18); // 20%
        _mint(lpWallet,   10_000_000 * 10**18); // 10%
        _mint(publicSale, 70_000_000 * 10**18); // 70%
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function redeemETH() external onlyOwner {
        require(address(this).balance > 0, "No ETH");
        payable(owner()).transfer(address(this).balance);
    }

    function recoverToken(IERC20 token, uint256 amount) external onlyOwner {
        require(token.balanceOf(address(this)) >= amount, "Low balance");
        token.transfer(owner(), amount);
    }

    receive() external payable {}
}
