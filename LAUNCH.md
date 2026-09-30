# $HOOD launch checklist (Robinhood Chain 4663)

Draft package only. Check every box before broadcasting. Accent / brand: Hood Street `#CCFF00`. Separate from `$CCFF00`.

---

## 1. Pre-flight

- [ ] Confirm token **name** `HOOD` / **symbol** `HOOD` / **18** decimals
- [ ] Confirm **chain id 4663** (Robinhood Chain mainnet)
- [ ] Confirm **fixed supply** `1_000_000_000e18` (1B HOOD) — change in `Hood.sol` + rebuild if different
- [ ] Decide **treasury / mint recipient** wallet (EOA or Safe) — constructor `recipient` (or leave `address(0)` → owner)
- [ ] Decide **agent fee recipient** wallet (where swap/LP fee proceeds land) — may equal treasury
- [ ] Confirm deployer funded with RH gas on 4663
- [ ] Copy `.env.example` → `.env`; set `PRIVATE_KEY` and `RPC_URL` locally (**never commit `.env`**)

---

## 2. Deploy + verify

- [ ] `forge build` clean (solc **0.8.20**, optimizer **OFF**, EVM **shanghai**)
- [ ] Dry-run: `forge script script/DeployHood.s.sol:DeployHood --rpc-url "$RPC_URL" --chain-id 4663` (no `--broadcast`)
- [ ] Broadcast deploy when ready (see README)
- [ ] Record contract address → set `VITE_HOOD_TOKEN` later
- [ ] Verify on Blockscout: https://robinhoodchain.blockscout.com
  - solc `0.8.20`
  - optimizer **disabled**
  - EVM shanghai
  - constructor args: `(address initialOwner, address recipient)`
  - Example:
    ```bash
    forge verify-contract <ADDRESS> contracts/Hood.sol:Hood \
      --chain-id 4663 \
      --compiler-version 0.8.20 \
      --verifier blockscout \
      --verifier-url https://robinhoodchain.blockscout.com/api/ \
      --constructor-args $(cast abi-encode "constructor(address,address)" <OWNER> <RECIPIENT>)
    ```

---

## 3. Create LP

- [ ] **TODO: confirm which DEX / AMM is live on RH chain 4663** — do not invent router addresses
- [ ] Once known: create HOOD / native (or HOOD / stable) pool with chosen initial liquidity
- [ ] Document pair + router + pool addresses here after creation:
  - Router: _(TBD)_
  - Pair / pool: _(TBD)_
  - Initial LP size: _(TBD)_

---

## 4. Lock LP

- [ ] Lock LP tokens (tool TBD — e.g. team locker, Unicrypt-style, or RH-native locker if available)
- [ ] Publish lock tx / locker UI link for community transparency
- [ ] Lock duration / unlock terms: _(TBD)_

---

## 5. Fee path → agent treasury

Token is a **clean ERC-20** (no transfer tax). Fees that fund the Hood agent + community must come from the DEX layer:

| Option | How it works | Recommendation |
| --- | --- | --- |
| **A. DEX fee tier** | Use a pool fee tier (e.g. 0.3% / 1%) where protocol or custom fee recipient can be set to agent treasury | **Preferred if the RH DEX supports a fee recipient / protocol fee** — simplest: no extra contracts |
| **B. Separate fee router** | Custom router that takes a small cut on swaps and forwards to treasury | Use only if DEX has no fee-recipient hook |
| **C. Manual / off-chain** | Periodically skim LP fees / trading revenue to treasury | Fallback for early launch |

- [ ] Pick option (recommend **A** if available)
- [ ] Set fee recipient = agent treasury / community wallet
- [ ] Document fee % and recipient address publicly

---

## 6. Wire into Hood Terminal / agent

- [ ] Set `VITE_HOOD_TOKEN=<deployed address>` in the terminal / agent env
- [ ] Point any Bankr-like agent treasury config at the fee recipient
- [ ] Smoke-test balance / allowance reads from the UI on chain 4663
- [ ] Do **not** confuse with `$CCFF00` — different contract address

---

## 7. Safety

- [ ] No `PRIVATE_KEY` in git (only `.env.example` with empty placeholders)
- [ ] No logging of private keys in scripts or CI
- [ ] Contract has **no** blacklist, pause, or post-deploy mint
- [ ] Ownership retained only for optional future non-mint roles — consider renouncing or transferring to a Safe after launch if unused
- [ ] LP lock completed and linked in launch announcement

---

## Open questions

1. **Which DEX/AMM on Robinhood Chain 4663?** Router + factory addresses unknown in this draft — confirm before LP creation.
2. **Does that DEX support a custom fee recipient / protocol fee?** Determines option A vs B above.
3. **LP lock tool** available on 4663?
4. Final **treasury** vs **agent fee recipient** — same wallet or split?
