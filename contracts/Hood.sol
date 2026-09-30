// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/// @title HOOD — companion ERC-20 for the Hood agent (Hood Street)
/// @notice Clean fixed-supply ERC-20. No transfer tax, no reflections, no
///         blacklist, no pause, no mint-after-deploy.
/// @dev Fair-launch companion coin for Robinhood Chain (4663). Accent #CCFF00.
///      Swap/LP fees that fund the agent treasury are handled at the DEX /
///      fee-router layer — not inside this token.
contract Hood is ERC20, Ownable {
    /// @notice Fixed total supply: 1,000,000,000 HOOD (18 decimals).
    uint256 public constant TOTAL_SUPPLY = 1_000_000_000 ether;

    /// @param initialOwner Account that receives Ownable rights (and, if
    ///        `recipient` is address(0), also receives the full mint).
    /// @param recipient Address that receives the full fixed supply.
    ///        Pass address(0) to mint to `initialOwner` / msg.sender path.
    constructor(address initialOwner, address recipient)
        ERC20("HOOD", "HOOD")
        Ownable(initialOwner)
    {
        address to = recipient == address(0) ? initialOwner : recipient;
        _mint(to, TOTAL_SUPPLY);
    }

    // Ownable is retained for optional future off-chain / agent roles only.
    // There is intentionally no ownerMint / pause / blacklist surface here.
}
