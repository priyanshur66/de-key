# DPKI

Decentralized Public Key Infrastructure.

This project is intended to improve security and usability of keys distribution and make chain of trust more distributed.

This theme is very crucial for IIoT and DePIN sector. There are a lot of new devices setup every day with various purposes, from home to industrial. IIoT area is expected billion of devices in the near future. To have secure and automated infrastructure for certificates distributing and rotation is important for proper, healthy and secure work of the any project or company. Here we come with DPKI solution for DePIN.

- [Here you can check sequence diagram to understand](./docs/render/Flow.png) **how it works**.
- [Chain of trust description](./docs/chain_of_trust.md) **and how it works**.

In simple words, we propose a way to generate a new key pair for any client or server by the admin user. Sign them using the Certificate Authority (CA). Then, using Diffie-Hellman key exchange, encrypt this key pair and distribute it through IPFS. To verify the integrity of the key pair, customer can use the smart contract. It can notify clients about new key pair availability through the smart contract and claim key pair hashes. After downloading it from IPFS and decryption, client can apply key pair locally (for example new SSH key pair or SSH CA). With such an approach, the **client** can be **sure** that this **key pair belongs** to the **particular admin** and can **trust** it. And by **encrypted way** of distribution **keys** can be **rotated often** to **improve** overall **system security.** Last but not least, everything can be done **without centralized servers** and **doesn't require** to have **own infrastructure.**

<br>

<p align="center">
  <img src="./docs/images/general.png" alt="general" width="400"/>
</p>

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
