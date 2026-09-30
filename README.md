# $HOOD — Hood companion token (draft)

Fair-launch companion ERC-20 for the **Hood** agent (Bankr-like, Hood Street style, accent `#CCFF00`) on **Robinhood Chain** (chain id **4663**).

Separate from existing `$CCFF00`. This package is a **draft** — do not deploy until `LAUNCH.md` is complete.

## Token specs

| Field | Value |
| --- | --- |
| Name | `HOOD` |
| Symbol | `HOOD` |
| Decimals | `18` |
| Total supply | `1_000_000_000e18` (1 billion HOOD) |
| Mint | Once in constructor to deployer / optional recipient |
| Tax / reflections | **None** (clean ERC-20) |
| Admin mint / pause / blacklist | **None** |
| Ownable | OpenZeppelin `Ownable` — ownership only; no privileged mint |

Swap / LP fees that fund the agent treasury + community are **not** baked into transfers. Use DEX fee tiers or an external fee router (see `LAUNCH.md`).

## Stack

- Foundry (`forge`)
- solc **0.8.20**, optimizer **OFF**, EVM **shanghai** (matches RobinGM patterns)
- OpenZeppelin Contracts **v5.0.2** (`ERC20` + `Ownable`)
- forge-std

## Layout

```
hood-token/
  contracts/Hood.sol
  script/DeployHood.s.sol
  foundry.toml
  remappings.txt
  .env.example
  LAUNCH.md
  README.md
```

## Build

```bash
cd /Users/poker.vibe/Desktop/hood-token
forge build
```

## Deploy (skeleton only — see LAUNCH.md)

```bash
cp .env.example .env   # fill PRIVATE_KEY locally; never commit
source .env            # or use dotenv / direnv
forge script script/DeployHood.s.sol:DeployHood \
  --rpc-url "$RPC_URL" \
  --broadcast \
  --chain-id 4663
```

**Do not** print or commit `PRIVATE_KEY`. After deploy, set `VITE_HOOD_TOKEN=<address>` in the Hood Terminal / agent env.

## Verify (Blockscout)

```bash
forge verify-contract <ADDRESS> contracts/Hood.sol:Hood \
  --chain-id 4663 \
  --compiler-version 0.8.20 \
  --verifier blockscout \
  --verifier-url https://robinhoodchain.blockscout.com/api/ \
  --constructor-args $(cast abi-encode "constructor(address,address)" <OWNER> <RECIPIENT>)
```

Match `foundry.toml`: solc 0.8.20, optimizer off, shanghai.

## Safety

- `.env` is gitignored; only `.env.example` ships with empty placeholders
- Contract has no hidden mint, pause, or blacklist
- Liquidity lock is a launch checklist item, not on-chain logic
