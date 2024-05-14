# Contracts

## Lisk Sepolia testnet

Latest deployed smart contract.

https://sepolia-blockscout.lisk.com/address/0x17536460b997842f8396409514986905eF63b58E

## Usage

Do not forget to set `.env` file.

```.env
RPC_URL=https://rpc.sepolia-api.lisk.com
PRIVATE_KEY=<private-key>
```

## VSCode

.vscode/settings.json

```json
{
  "solidity.packageDefaultDependenciesContractsDirectory": "contracts/src",
  "solidity.packageDefaultDependenciesDirectory": "contracts/lib",
  "solidity.formatter": "forge",
  "solidity.compileUsingRemoteVersion": "v0.8.23+commit.f704f362",
}
```
