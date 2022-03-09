// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity >=0.8.0;

import {DSTest} from "ds-test/test.sol";
import {ForwardProxy} from "forward-proxy/ForwardProxy.sol";
import {DummyToken} from "./DummyToken.sol";

interface Hevm {
    function warp(uint256) external;

    function store(
        address,
        bytes32,
        bytes32
    ) external;

    function load(address, bytes32) external view returns (bytes32);
}

contract DummyTokenTest is DSTest {
    // CHEAT_CODE = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D
    bytes20 internal constant CHEAT_CODE = bytes20(uint160(uint256(keccak256("hevm cheat code"))));

    Hevm internal hevm;

    ForwardProxy internal notOwner;
    DummyToken internal token;

    function setUp() public {
        hevm = Hevm(address(CHEAT_CODE));

        notOwner = new ForwardProxy();
        token = new DummyToken("Dummy", "DUMMY");
    }

    function testOwnerCanMint() public {
        token.mint(address(this), 100 ether);

        assertEq(token.totalSupply(), 100 ether);
        assertEq(token.balanceOf(address(this)), 100 ether);
    }

    function testOwnerCanBurn() public {
        token.mint(address(this), 100 ether);

        token.burn(address(this), 50 ether);

        assertEq(token.totalSupply(), 50 ether);
        assertEq(token.balanceOf(address(this)), 50 ether);
    }

    function testFailCannotMintIfIsNotOwner() public {
        DummyToken(notOwner._(address(token))).mint(address(notOwner), 100);
    }

    function testFailCannotBurnIfIsNotOwner() public {
        token.mint(address(notOwner), 100 ether);

        DummyToken(notOwner._(address(token))).burn(address(notOwner), 50);
    }
}
