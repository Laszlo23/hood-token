// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console2} from "forge-std/Script.sol";
import {Hood} from "../contracts/Hood.sol";

/// @title DeployHood — skeleton deploy for $HOOD on Robinhood Chain (4663)
/// @dev Reads PRIVATE_KEY from env but never logs it.
///
/// Example (do NOT run until launch checklist is complete):
///   forge script script/DeployHood.s.sol:DeployHood \
///     --rpc-url "$RPC_URL" \
///     --broadcast \
///     --chain-id 4663
///
/// RPC (known from prior RH projects):
///   https://rpc.mainnet.chain.robinhood.com
///
/// Optional constructor override:
///   INITIAL_OWNER=0x...   (defaults to deployer)
///   MINT_RECIPIENT=0x...  (defaults to initial owner; address(0) also → owner)
contract DeployHood is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(pk);

        address initialOwner = vm.envOr("INITIAL_OWNER", deployer);
        address mintRecipient = vm.envOr("MINT_RECIPIENT", initialOwner);

        vm.startBroadcast(pk);
        Hood token = new Hood(initialOwner, mintRecipient);
        vm.stopBroadcast();

        // Safe to log: addresses and supply only — never the key.
        console2.log("HOOD deployed at:", address(token));
        console2.log("Owner:", initialOwner);
        console2.log("Mint recipient:", mintRecipient);
        console2.log("Total supply (wei):", token.TOTAL_SUPPLY());
    }
}
