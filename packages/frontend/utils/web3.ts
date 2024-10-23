// utils/web3.ts
import { ethers } from 'ethers';
import { Web3Provider } from '@ethersproject/providers';
import Boilerplate from '../constants/Boilerplate.json';

const CONTRACT_ADDRESS = process.env.NEXT_PUBLIC_CONTRACT_ADDRESS;
const RPC_URL = process.env.NEXT_PUBLIC_RPC_URL;

// 定義: アーティファクトの型
interface ContractArtifact {
  abi: any[];
  bytecode: string;
  // 必要に応じて他のフィールドも追加
}

// アーティファクトからABIを抽出
const { abi } = Boilerplate as ContractArtifact;

// プロバイダーの作成 (ethers v6対応)
export const provider = new ethers.JsonRpcProvider(RPC_URL);

// サイナーの作成 (ethers v6対応)
export const getSigner = async (): Promise<ethers.Signer> => {
  if (typeof window !== 'undefined' && typeof (window as any).ethereum !== 'undefined') {
    const web3Provider = new ethers.BrowserProvider((window as any).ethereum);
    return await web3Provider.getSigner();
  }
  throw new Error('Cryptoウォレットが見つかりません。');
};

// コントラクトインスタンスの作成 (ethers v6対応)
export const getContract = async (): Promise<ethers.Contract> => {
  const signer = await getSigner();
  if (!CONTRACT_ADDRESS) {
    throw new Error('コントラクトアドレスが設定されていません。');
  }
  return new ethers.Contract(CONTRACT_ADDRESS, abi, signer);
};