# Local Development Setup

This guide details the manual setup of Flightly without containerization, ideal for local development and debugging.

## Prerequisites
- Node.js (18.x recommended)
- MongoDB (7.0 recommended)

## 1. Database Installation (Ubuntu)

```bash
# Add MongoDB repository and install
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt update
sudo apt install -y mongodb-org

# Enable and start the service
sudo systemctl enable mongod
sudo systemctl start mongod
```

## 2. Backend Setup

```bash
cd backend
sudo apt update
sudo apt install -y build-essential python3 make g++
npm install
npm rebuild bcrypt --build-from-source
npm run devStart
```
Backend will be available at `http://localhost:5000`.

## 3. Frontend Setup

```bash
cd frontend
npm install
npm install @kommunicate/kommunicate-chatbot-plugin
export NODE_OPTIONS=--openssl-legacy-provider
npm start
```
Frontend will be available at `http://localhost:3000`.
