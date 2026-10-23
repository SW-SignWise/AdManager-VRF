# Encrypted Foundry signers

Import each EVM account with `cast wallet import <name> --interactive`. The CLI
uses hidden password prompts; unattended runs require `ETH_PASSWORD` pointing
to a separate password file. Raw key environment values are unsupported.

| Previous raw variable | Account selector |
| --- | --- |
| `PRIVATE_KEY` | `ETH_KEYSTORE_ACCOUNT` |
| `PRIVATE_KEY2` | `KEYSTORE_ACCOUNT2` |

Configure a full encrypted file path with the selector's KEYSTORE counterpart.
Explicit unlock failures do not select another wallet. Verify public addresses,
then remove legacy values from local, CI and deployed environments. Previously
exposed keys must be rotated. No live bot operation or transaction was run.
