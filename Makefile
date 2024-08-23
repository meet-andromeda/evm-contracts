# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
install:; forge install
update:; forge update

# Build & test
build  :; forge build
test   :; forge test
test-polygon-fork :; forge test --fork-url https://polygon-mainnet.g.alchemy.com/v2/$(ALCHEMY_POLY_API_KEY) --ffi -vvv
test-mainnet-fork :; forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/$(ALCHEMY_ETH_API_KEY) --ffi -vvv
trace   :; forge test -vvv
clean  :; forge clean
snapshot :; forge snapshot
fmt    :; forge fmt