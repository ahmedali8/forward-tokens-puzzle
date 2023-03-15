// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ITest } from "./ITest.sol";

contract Test is ITest {
    IERC20 internal token;

    constructor(IERC20 _token) {
        token = _token;
    }

    function forward(address sender, address receiver, uint256 amount) external override {
        token.transferFrom(sender, receiver, amount);
    }
}
