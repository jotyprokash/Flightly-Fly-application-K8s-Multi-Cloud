# =========================
# Stage 1: Build
# =========================
FROM node:18-alpine AS build

WORKDIR /app

ENV NODE_OPTIONS=--openssl-legacy-provider

COPY package*.json ./
RUN npm install \
 && npm install @kommunicate/kommunicate-chatbot-plugin

COPY . .

RUN npm run build


# =========================
# Stage 2: Runtime
# =========================
FROM nginx:1.25-alpine

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build output only
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]