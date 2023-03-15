// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { MyToken } from "src/MyToken.sol";
import { AnotherContract } from "src/AnotherContract.sol";
import { Test } from "src/Test.sol";
import { ITest } from "src/ITest.sol";

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract AnotherContractTest is PRBTest, StdCheats {
    MyToken internal myToken;
    AnotherContract internal anotherContract;
    Test internal test;

    address internal receiver;

    function setUp() public {
        receiver = makeAddr("receiver");
        vm.deal({ account: receiver, newBalance: 100 ether });

        // deploy MyToken
        myToken = new MyToken();

        // deploy Test
        test = new Test(IERC20(myToken));

        // deploy AnotherContract
        anotherContract = new AnotherContract(ITest(test), IERC20(myToken));

        uint256 balanceOfThisContract = myToken.balanceOf(address(this));
        console2.log(balanceOfThisContract);

        // transfer tokens to AnotherContract
        myToken.transfer(address(anotherContract), balanceOfThisContract);
    }

    /// @dev Simple test. Run Forge with `-vvvv` to see console logs.
    function test_ReceiverBalance() external {
        assertEq(myToken.balanceOf(address(anotherContract)), 1000e18);

        assertEq(myToken.balanceOf(receiver), 0);

        // call sendTokens
        anotherContract.sendTokens(receiver);

        assertEq(myToken.balanceOf(receiver), 1000e18);
    }
}
