# Decentralized Ad Distribution System

## Overview
The Decentralized Ad Distribution System is a blockchain-based platform designed to streamline the interaction between advertisers and content providers. This system ensures transparency and fairness in advertising by leveraging smart contracts to manage campaigns, track impressions, process payments, and ensure content provider eligibility. The platform allows advertisers to launch campaigns, manage funding, and track performance, while content providers can earn revenue through ad impressions.

## Features
- **Decentralized Campaign Management**: Advertisers can create campaigns with set funding, impression goals, and duration.
- **Impression Tracking**: Every impression is logged and tracked on-chain, ensuring accurate reporting and revenue distribution.
- **Content Provider Registry**: Verified content providers can register to participate in campaigns and earn revenue.
- **Revenue and Performance Metrics**: Real-time metrics for both advertisers and content providers.
- **Secure Payments**: Payment for impressions is made through smart contracts to ensure security and transparency.
- **Administration Functions**: Admins can manage system fees and verify content provider eligibility.

## Key Components
- **AdCampaigns**: Storage for ad campaign data, including funding, impressions, and campaign status.
- **AuthorizedContentProviders**: A registry of content providers, their verification status, and revenue metrics.
- **AdvertiserPerformance**: Tracks the performance and spending metrics of advertisers.
- **ImpressionsByDay**: Tracks the number of impressions logged for each ad campaign on a daily basis.
- **System Fee**: A configurable system fee that is applied to each transaction.

## Smart Contract Functions
- **register-impression**: Records impressions for a specific ad, checks eligibility of content provider, and ensures payment.
- **modify-system-fee**: Admin function to modify the system's fee rate.
- **get-ad-performance**: Retrieves performance metrics for a specific ad campaign.
- **get-provider-statistics**: Retrieves metrics for a specific content provider.

## Setup

### Prerequisites
- A compatible blockchain environment (e.g., Stacks blockchain).
- Tools to deploy smart contracts (e.g., Clarinet for testing and deployment).

### Deploying the System
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/decentralized-ad-distribution-system.git
   cd decentralized-ad-distribution-system
   ```

2. Install dependencies (if applicable).

3. Deploy the smart contract to the blockchain using your preferred tool (e.g., Clarinet).

### Interacting with the Contract
Once deployed, you can interact with the contract using transaction calls. Below are some example calls:

- Register an impression:
  ```bash
  call register-impression --ad-id <ad-id> --content-provider <provider-address> --verification-hash <hash>
  ```

- Modify the system fee (Admin only):
  ```bash
  call modify-system-fee --new-basis-points <value>
  ```

- Retrieve ad performance:
  ```bash
  call get-ad-performance --ad-id <ad-id>
  ```

- Retrieve provider statistics:
  ```bash
  call get-provider-statistics --content-provider <provider-address>
  ```

## Contributing
Contributions are welcome! Please submit issues, feature requests, and pull requests. We follow a standard Git flow and encourage collaborative improvements.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
