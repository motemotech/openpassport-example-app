'use client';

import { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import { useAccount } from 'wagmi';
import { getContract } from '../utils/web3';
import { ConnectButton } from '@rainbow-me/rainbowkit';

export default function Home() {
  const { address, isConnected } = useAccount();
  const [currentAccount, setCurrentAccount] = useState<string | null>(null);
  const [attestation, setAttestation] = useState('');
  const [status, setStatus] = useState('');

  useEffect(() => {
    if (isConnected && address) {
      setCurrentAccount(address);
    } else {
      setCurrentAccount(null);
    }
  }, [isConnected, address]);

  // Mint Function
  const mint = async () => {
    if (!currentAccount) {
      setStatus('Please connect your wallet first.');
      return;
    }

    try {
      const contract = await getContract();
      // Assuming `attestation` needs to be structured as per your contract's requirements
      const tx = await contract.mint(attestation);
      setStatus('Transaction submitted. Waiting for confirmation...');
      await tx.wait();
      setStatus('Minted successfully!');
    } catch (error) {
      console.error(error);
      setStatus('Transaction failed.');
    }
  };

  return (
    <div style={{ padding: '2rem' }}>
      <h1>OpenPassport Minting</h1>
      <ConnectButton />

      {currentAccount && (
        <p style={{ marginTop: '1rem' }}>Connected as: {currentAccount}</p>
      )}

      <div style={{ marginTop: '1rem' }}>
        <textarea
          placeholder="Enter attestation data..."
          value={attestation}
          onChange={(e) => setAttestation(e.target.value)}
          rows={4}
          cols={50}
        />
      </div>

      <button onClick={mint} style={{ marginTop: '1rem' }}>
        Mint OpenPassport
      </button>

      {status && <p>{status}</p>}
    </div>
  );
}