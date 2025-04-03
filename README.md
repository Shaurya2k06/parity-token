# Parity Token

This repository contains an ERC‑20 token implementation along with deployment and management scripts. The project is built with [Foundry](https://book.getfoundry.sh/) and leverages [OpenZeppelin](https://openzeppelin.com/) contracts for secure and standardized token development.

## Features

- **ERC‑20 Standard Token**: Secure implementation using OpenZeppelin's audited contracts.
- **Enhanced Deployment Scripts**:
  - Automatic network detection (Sepolia/Mainnet/Local)
  - Gas cost estimation and balance validation
  - Detailed deployment status and progress
  - Automatic Etherscan verification instructions
- **Smart Transfer Management**:
  - Pre-transfer balance checks
  - Gas cost estimation
  - Detailed transaction reporting
  - Network-aware error messages
- **Environment Management**: Uses environment variables for secure handling of sensitive configurations.

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation.html) installed
- An Ethereum wallet with testnet ETH (for deploying to networks like Sepolia)

## Setup & Installation

1. **Clone the repository with submodules:**

   ```bash
   git clone --recursive https://github.com/theblitlabs/parity-token.git
   cd parity-token
   ```

   If you've already cloned the repository without `--recursive`, run:

   ```bash
   make install
   ```

   This will initialize and update all required submodules.

2. **Install Git Hooks:**

   ```bash
   make install-hooks
   ```

   This will install pre-commit hooks for:

   - Code formatting checks
   - Linting
   - Test execution
   - Conventional commit message validation

3. **Dependencies:**
   The project uses git submodules for dependency management:

   - `forge-std`: Foundry's standard library for testing and scripting
   - `openzeppelin-contracts`: OpenZeppelin's secure contract library

   Dependencies are pinned to specific commits for reproducible builds.

4. **Configure Environment Variables:**

   - Copy the environment template:
     ```bash
     cp .env.example .env
     ```
   - Update `.env` with your credentials:

     ```
     # Network RPC URLs
     SEPOLIA_RPC_URL="your RPC URL"
     MAINNET_RPC_URL="your mainnet RPC URL"  # Optional

     # Wallet Configuration
     PRIVATE_KEY="your wallet private key"  # with 0x prefix

     # API Keys
     ETHERSCAN_API_KEY="your etherscan key"  # Optional, for verification
     ```

## Documentation

For detailed Foundry usage, visit: https://book.getfoundry.sh/

## Usage

The project includes a Makefile for common operations. Here are the main commands:

### Development

```shell
# Install/update dependencies
$ make install

# Build the project
$ make build

# Run tests
$ make test

# Run tests with gas reporting
$ make test-gas

# Format code
$ make format

# Clean build artifacts
$ make clean

# Update dependencies
$ make update
```

### Deployment

```shell
# Start local node
$ make anvil

# Deploy to local network
$ make deploy-local

# Deploy to Sepolia testnet (requires .env configuration)
$ make deploy-sepolia

# Transfer tokens locally
$ make transfer-local ADDRESS="recipient-address" AMOUNT="amount"

# Transfer tokens on Sepolia
$ make transfer-sepolia ADDRESS="recipient-address" AMOUNT="amount"
```

The deployment script will:

1. Detect the network automatically
2. Use environment variables from `.env` for configuration
3. Estimate gas costs
4. Validate wallet balance
5. Show detailed deployment progress
6. Provide verification instructions

The transfer script will:

1. Use configured token address from `.env`
2. Validate addresses and amounts
3. Check token and ETH balances
4. Estimate gas costs
5. Show detailed transfer status
6. Report final balances and transaction cost

Note: For testnet operations:

- Ensure your `.env` file is properly configured
- Ensure sufficient ETH for gas (scripts will estimate costs)
- For Sepolia testnet, the scripts will provide faucet links if needed

## Development

This project uses [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules) for dependency management, ensuring reproducible builds and consistent development environments.

### Dependency Management

1. **After Pulling Changes:**
   Always run after pulling changes that modify submodules:

   ```bash
   make install
   ```

2. **Working with Dependencies:**

   - Update all: `make update`
   - View status: `git submodule status`

3. **Committing Changes:**
   - Submodule changes need to be committed separately
   - Always test after updating dependencies
   - Verify builds are reproducible

### Development Workflow

1. **Local Development:**

   ```bash
   # Start local node
   make anvil

   # Deploy locally
   make deploy-local
   ```

2. **Testing:**

   ```bash
   # Run all tests
   make test

   # Run with gas reporting
   make test-gas
   ```

3. **Code Quality:**

   ```bash
   # Format code
   make format

   # Build and check sizes
   make build
   ```

## Best Practices & Security

### Security Considerations

- **Secure Credentials:** Never commit your `.env` file or expose private keys
- **Audited Dependencies:** Using OpenZeppelin's audited contracts
- **Automated Verification:** Etherscan verification in deployment process
- **Reproducible Builds:** Dependencies pinned via git submodules

### Development Guidelines

- **Testing:** Write comprehensive tests for all new features
- **Gas Optimization:** Monitor gas usage with `make test-gas`
- **Code Style:** Use `make format` before committing
- **Dependencies:** Document any new dependencies added

### CI/CD Pipeline

- Automated testing on pull requests
- Security analysis with Slither
- Gas usage monitoring
- Testnet deployment verification

## Contributing

Contributions are welcome! Please open an issue or submit a pull request if you have any enhancements or bug fixes.

## License

This project is licensed under the MIT License.
