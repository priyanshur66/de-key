#!make
include .env

build:
	forge build --use 0.8.22

test: lint
	forge test --use 0.8.22 --gas-report --summary --detailed -vv

coverage: test
	forge coverage --use 0.8.22 --report summary

lint:
	forge fmt

anvil:
	anvil --block-time 1

deploy:
	PRIVATE_KEY=${PRIVATE_KEY} \
		forge script --use 0.8.22 script/DPKI.s.sol:DPKIScript \
		--fork-url ${RPC_URL} --broadcast -vvvv
