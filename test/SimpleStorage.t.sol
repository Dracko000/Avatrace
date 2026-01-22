// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/SimpleStorage.sol";

contract SimpleStorageTest is Test {
    SimpleStorage public simpleStorage;

    function setUp() public {
        simpleStorage = new SimpleStorage();
    }

    function testSetAndGetData() public {
        simpleStorage.set(42);
        assertEq(simpleStorage.get(), 42);
    }

    function testInitialValueIsZero() public {
        assertEq(simpleStorage.get(), 0);
    }
}