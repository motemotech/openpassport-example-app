import { createPublicClient, http } from 'viem';
import { sepolia } from 'viem/chains';
import { getContract, publicActions } from 'viem';
import BoilerplateABI from '../../abi/BoilerplateABI.json';

const CONTRACT_ADDRESS = '0xYourContractAddressHere';

export const client = createPublicClient({
  chain: sepolia,
  transport: http(),
});

// コントラクトインスタンスの作成
export const getBoilerplateContract = () => {
  return getContract({
    address: CONTRACT_ADDRESS,
    abi: BoilerplateABI.abi,
    client: client,
  });
};
