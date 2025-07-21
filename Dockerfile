# Multi-stage Dockerfile for nextjs frontend

# Builder stage
FROM node:18-alpine AS builder
WORKDIR /app

# Copy manifest and lock files
COPY package*.json ./
RUN npm install

# Copy all sources
COPY . .
RUN npm run build

FROM node:18-alpine AS production
WORKDIR /app

# Copy built code and production dependencies
COPY --from=builder /app/package*.json ./
RUN npm install
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 80
#CMD ["npm", "run", "start"]
CMD ["sh", "-c", "PORT=80 npm run start"]
