# Flightly

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![GitOps](https://img.shields.io/badge/GitOps-enabled-brightgreen?style=for-the-badge&logo=git)
![CI/CD](https://img.shields.io/badge/CI%2FCD-Active-blue?style=for-the-badge&logo=githubactions&logoColor=white)
![React](https://img.shields.io/badge/react-%2320232a.svg?style=for-the-badge&logo=react&logoColor=%2361DAFB)
![Node.js](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
Flightly is a full-stack airline reservation and management system designed for robust, scalable deployment.

![Flightly Landing Page](docs/assets/preview.png)

## Architecture

- **Frontend:** React (SPA)
- **Backend:** Node.js, Express (REST API)
- **Database:** MongoDB
- **Infrastructure:** Docker, Kubernetes

```mermaid
%%{init: {'theme': 'base', 'themeVariables': { 'primaryColor': '#f4f4f4', 'primaryBorderColor': '#bcbcbc' }}}%%
graph LR
    Client((User)) -->|HTTP| UI(React Frontend UI)
    UI -->|REST| API(Node.js API Services)
    API -->|TCP| DB[(MongoDB)]
```

## Quick Start (Docker)

The fastest way to spin up the entire stack locally:

```bash
docker compose up -d
```
- Frontend Access: `http://localhost:3000`
- Backend API: `http://localhost:5000`

## Local Deployment (Manual)

For active development, you can run the services natively.

1. **Database**: Ensure MongoDB is installed and running locally on port `27017`.
2. **Backend**:
   ```bash
   cd backend && npm install && npm run devStart
   ```
3. **Frontend**:
   ```bash
   cd frontend && npm install && export NODE_OPTIONS=--openssl-legacy-provider && npm start
   ```

> **Note**: For detailed system requirements and fresh dependency installation (e.g., Ubuntu package commands for MongoDB/Node.js), refer to the [Local Development Guide](./docs/local-development.md).

## Kubernetes Deployment

To deploy Flightly to a local Kubernetes cluster, navigate to the Kubernetes deployment directories. A guided reference for Minikube is available in the [Minikube Walkthrough](./minikube-1/02-minikube/walkthrough.md).

## Contributing

Contributions are welcome. Please ensure any feature additions are accompanied by appropriate test coverage and documentation updates to maintain project stability.
