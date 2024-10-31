import { createPublicClient, http } from 'viem';
import { sepolia } from 'viem/chains';
import { getContract, publicActions } from 'viem';
import BoilerplateABI from '../../abi/BoilerplateABI.json';

const CONTRACT_ADDRESS = '0x9b1c2a0c28903deb2abe4fcefe344acee1e5831a';

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
