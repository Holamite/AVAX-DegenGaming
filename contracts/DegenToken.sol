// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenToken is ERC20 {
    address gameOwner;
    uint256 public tokenPrice;
    uint256 public healthCost;
    uint256 public skinCost;
    uint256 public emblemCost;

    constructor() ERC20("DegenToken", "DGN") {
        gameOwner = msg.sender;
        tokenPrice = 100;
        healthCost = 10;
        skinCost = 5;
        emblemCost = 2;
    }

    modifier onlyOwners() {
        require(msg.sender == gameOwner, "you are not the owner");
        _;
    }

    function mintDegenToken(
        address _player,
        uint256 _amount
    ) public virtual onlyOwners {
        _mint(_player, _amount);
    }

    function burnDegenToken(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function transferDegenToken(address to, uint256 amount) public {
        _transfer(msg.sender, to, amount);
    }

    function buyToken() public payable {
        uint256 amount = msg.value / tokenPrice;
        _mint(msg.sender, amount);
    }

    function getTokenBalance(address player) public view returns (uint256) {
        return balanceOf(player);
    }

    function showStore() external pure returns (string memory) {
        return "Health , Skin , Emblems";
    }

    function redeemItem(string calldata _item) public {
        if (
            keccak256(abi.encodePacked(_item)) ==
            keccak256(abi.encodePacked("Health"))
        ) {
            require(
                balanceOf(msg.sender) >= healthCost,
                "Not enough Degen Tokens to buy health"
            );
            _burn(msg.sender, healthCost);
            // grant health to player
        } else if (
            keccak256(abi.encodePacked(_item)) ==
            keccak256(abi.encodePacked("Skin"))
        ) {
            require(
                balanceOf(msg.sender) >= skinCost,
                "Not enough Degen Tokens to buy skin"
            );
            _burn(msg.sender, skinCost);
            // grant skin to player
        } else if (
            keccak256(abi.encodePacked(_item)) ==
            keccak256(abi.encodePacked("Emblem"))
        ) {
            require(
                balanceOf(msg.sender) >= emblemCost,
                "Not enough Degen Tokens to buy emblem"
            );
            _burn(msg.sender, emblemCost);
            // grant emblem to player
        }
    }
}
