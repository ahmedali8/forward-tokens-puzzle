// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ITest } from "./ITest.sol";
import { MyToken } from "./MyToken.sol";

contract AnotherContract {
    ITest internal add;
    IERC20 internal myToken;

    constructor(ITest _add, IERC20 _myToken) {
        add = _add;
        myToken = _myToken;
    }

    function sendTokens(address _receiver) external {
        // call the forward function of test contract and.
        // send the balance of this address to receiver address

        myToken.approve(address(add), myToken.balanceOf(address(this)));

        add.forward(address(this), _receiver, myToken.balanceOf(address(this)));
    }
}
