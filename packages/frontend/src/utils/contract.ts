import { createPublicClient, http } from 'viem';
import { sepolia } from 'viem/chains';
import { getContract, publicActions } from 'viem';
import BoilerplateABI from '../../abi/BoilerplateABI.json';

const CONTRACT_ADDRESS = '0x7020933f26Fc11e40D47b797D8e662D7a79c330f';

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
