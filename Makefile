include .env
export

build:
	cd packages/contracts && forge build

deploy:
	cd packages/contracts && forge script script/DeployBoilerplate.sol:DeployBoilerplateScript --broadcast --rpc-url ${SEPOLIA_RPC_URL} --verify --etherscan-api-key ${SEPOLIA_SCAN_API_KEY}
