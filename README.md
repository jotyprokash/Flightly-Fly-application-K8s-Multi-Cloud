# Flightly – An Air Booking Web Application

Flightly is a full-stack air-booking web application that simulates a real-world airline reservation system. It allows users to register, authenticate, search routes, book seats, manage trips, and handle cancellations through a modern, responsive interface.

Built with **React, Node.js, Express, and MongoDB**, Flightly focuses on practical system design, secure authentication, and end-to-end booking workflows—making it ideal for demonstrating full‑stack engineering and backend integration skills.

---

## Tech Stack

- **Frontend:** React, npm
- **Backend:** Node.js, Express
- **Database:** MongoDB
- **Containerization:** Docker, Docker Compose

---

## Run Locally (Manual Setup)

### Install Node.js (Ubuntu)

From home directory:

```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
```

---

### Clone the Project

```bash
git clone https://github.com/jotyprokash/Flightly-An-Air-Booking-Web-App.git
```

---

### Run Frontend

```bash
cd ~/Flightly-An-Air-Booking-Web-App/frontend
npm install
npm install @kommunicate/kommunicate-chatbot-plugin
export NODE_OPTIONS=--openssl-legacy-provider
npm start
```

Frontend will be available at:
```
http://localhost:3000
```

---

### MongoDB Installation (Local)

```bash
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] \
https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | \
sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt update
sudo apt install -y mongodb-org

sudo systemctl start mongod
sudo systemctl enable mongod
systemctl status mongod
```

---

### Run Backend

```bash
cd ~/Flightly-An-Air-Booking-Web-App/backend
sudo apt update
sudo apt install -y build-essential python3 make g++
rm -rf node_modules package-lock.json
npm install
npm rebuild bcrypt --build-from-source
sudo npm install -g nodemon
nodemon -v
npm run devStart
```

Backend will be available at:
```
http://localhost:5000
```

---


### Build & Run with Docker 

```bash
docker compose build --no-cache
docker compose up -d
```

---

### Verify Containers

```bash
docker ps
```

Services:
- Frontend → http://localhost:3000
- Backend → http://localhost:5000
- MongoDB → mongodb://localhost:27017

---

### Stop & Clean Up

```bash
docker compose down -v
```

