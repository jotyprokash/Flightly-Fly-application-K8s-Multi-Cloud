#!/bin/bash
set -e

echo "Setting up GitHub Runner (Requires manual configuration variables)..."
mkdir -p actions-runner && cd actions-runner

# Download latest runner package
curl -o actions-runner-linux-x64-2.316.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.316.1/actions-runner-linux-x64-2.316.1.tar.gz

# Extract
tar xzf ./actions-runner-linux-x64-2.316.1.tar.gz

echo "The GitHub Self-Hosted Runner binaries have been downloaded and extracted."
echo "--------------------------------------------------------"
echo "ACTION REQUIRED: Run the following commands to configure and start the runner:"
echo "1. ./config.sh --url https://github.com/<OWNER>/<REPO> --token <TOKEN>"
echo "2. sudo ./svc.sh install"
echo "3. sudo ./svc.sh start"
echo "--------------------------------------------------------"
