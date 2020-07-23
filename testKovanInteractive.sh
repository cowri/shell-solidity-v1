#!/usr/bin/env bash
source .sethrc && DAPP_BUILD_EXTRACT=1 dapp build && DAPP_TEST_NUMBER=$(seth block latest number) DAPP_TEST_TIMESTAMP=$(seth block latest timestamp) hevm interactive --rpc $ETH_RPC_URL --json-file="out/dapp.sol.json" 
