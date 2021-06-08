const port = process.env.HOST_PORT || 9090

module.exports = {
  networks: {
    mainnet: {
      privateKey: process.env.PRIVATE_KEY_MAINNET,
      feeLimit: 1e8,
      fullHost: 'https://api.trongrid.io',
      fullNode: "https://api.trongrid.io",
      solidityNode: "https://api.trongrid.io",
      eventServer: "https://api.trongrid.io",
      fee_limit: 1e9,
      originEnergyLimit: 1e7,  // Set origin energy limit
      network_id: '1'
    },
    shasta: {
      privateKey: process.env.PRIVATE_KEY_SHASTA,
      fullNode: "https://api.shasta.trongrid.io",
      fullHost: "https://api.shasta.trongrid.io",
      solidityNode: "https://api.shasta.trongrid.io",
      eventServer: "https://api.shasta.trongrid.io",
      fee_limit: 1e9,
      originEnergyLimit: 1e7,  // Set origin energy limit
      network_id: '2'
    },
    development: {
      privateKey: process.env.PRIVATE_KEY_DEV,
      fullNode: "http://127.0.0.1:9090",
      fullHost: "http://127.0.0.1:9090",
      solidityNode: "http://127.0.0.1:9090",
      eventServer: "http://127.0.0.1:9090",
      fee_limit: 1000000000,
      network_id: '*'
    },
    compilers: {
      solc: {
        optimizer: {
          enabled: true,
          runs: 200
        },
        version: '0.5.15',
      }
    }
  }
}
