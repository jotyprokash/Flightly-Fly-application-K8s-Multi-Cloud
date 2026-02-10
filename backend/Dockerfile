# ---------- Builder (compile native deps like bcrypt) ----------
FROM node:18-bullseye AS builder

WORKDIR /app

# Tools needed for native modules (bcrypt)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 make g++ \
  && rm -rf /var/lib/apt/lists/*

# Install deps first for better cache
COPY package*.json ./
RUN npm ci

# Copy source
COPY . .

# Remove dev deps for production runtime
RUN npm prune --omit=dev


# ---------- Runtime (slim, non-root) ----------
FROM node:18-bullseye-slim AS runtime

WORKDIR /app
ENV NODE_ENV=production

# Run as non-root "node" user (already exists in official image)
USER node

# Copy only what we need
COPY --chown=node:node --from=builder /app /app

EXPOSE 8080

# If your app listens on a different port internally, adjust here.
CMD ["node", "./bin/www"]