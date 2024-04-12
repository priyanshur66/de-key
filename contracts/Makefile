#!make
include .env

build:
	forge build --use 0.8.22
	forge bind --overwrite --skip-build --single-file --module -b ../contracts-rs/src/contracts
	{ echo '#![allow(warnings)]'; cat ../contracts-rs/src/contracts/mod.rs; } > ../contracts-rs/src/contracts/mod.rs_
	rm -rf ../contracts-rs/src/contracts/mod.rs
	mv ../contracts-rs/src/contracts/mod.rs_ ../contracts-rs/src/contracts/mod.rs

test: lint
	forge test --use 0.8.22 --gas-report --summary --detailed -vv

coverage: test
	forge coverage --use 0.8.22 --report debug

lint:
	forge fmt

anvil:
	anvil --block-time 1

deploy:
	PRIVATE_KEY=${PRIVATE_KEY} \
		forge script --use 0.8.22 script/_.s.sol:_ \
		--fork-url ${RPC_URL} --broadcast -vvvv
