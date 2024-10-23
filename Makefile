build:
	forge build

deploy:
	forge script script/DeployBoilerplate.sol:DeployBoilerplateScript --broadcast --rpc-url ${SEPOLIA_RPC_URL} --verify --etherscan-api-key ${SEPOLIA_SCAN_API_KEY}