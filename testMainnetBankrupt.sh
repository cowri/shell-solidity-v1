#!/usr/bin/env bash
source .sethrc && dapp build && DAPP_TEST_ADDRESS=0x3d5F7a67e2F3f62c561aD4104f9fF50c3061753E DAPP_TEST_NUMBER=$(seth block latest number) DAPP_TEST_TIMESTAMP=$(seth block latest timestamp) hevm dapp-test --rpc $ETH_RPC_URL --json-file="out/dapp.sol.json" --verbose 2
