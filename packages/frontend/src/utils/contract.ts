import { createPublicClient, http } from 'viem';
import { sepolia } from 'viem/chains';
import { getContract, publicActions } from 'viem';
import BoilerplateABI from '../../abi/BoilerplateABI.json';

const CONTRACT_ADDRESS = '0xF55E1B9A423FC7b5759183B69510349382C11907';

export const client = createPublicClient({
  chain: sepolia,
  transport: http(),
});

export const getBoilerplateContract = () => {
  return getContract({
    address: CONTRACT_ADDRESS,
    abi: BoilerplateABI.abi,
    client: client,
  });
};
