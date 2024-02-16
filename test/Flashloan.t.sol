// SPDX-License-Identifier: GPL 3.0
pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {FlashLoan} from "../../src/FlashLoan.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TestFlashLoan is Test {
    IERC20 public weth;
    FlashLoan public flashLoan;
    address public constant WethAddressEthereum =
        0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        weth = IERC20(WethAddressEthereum);
        flashLoan = new FlashLoan(0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e);
    }

    function testDeposit() public {
        address user = address(123);
        // minting 2 WETH
        deal(address(weth), user, 2 * 1e18, false);

        vm.startPrank(user);
        // transfer 1 WETH to the flashLoan contract to pay the premium
        weth.transfer(address(flashLoan), 1e18);

        // check balance before flashloan
        console.log("Contract balance", weth.balanceOf(address(flashLoan)));

        // call flashLoan contract to create flashloan
        flashLoan.fn_RequestFlashLoan(WethAddressEthereum, 5 * 1e18);

        // check balance change
        console.log("Contract balance", weth.balanceOf(address(flashLoan)));

        vm.stopPrank();
    }
}
