// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract DummyToken is ERC20 {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "DummyToken/not-owner");
        _;
    }

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol, 18) {
        owner = msg.sender;
    }

    function transferOwnership(address _owner) external onlyOwner {
        owner = _owner;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
