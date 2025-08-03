# Build stage
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the app for production
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /usr/src/app

# Install serve globally
RUN npm install -g serve

# Copy built app from builder stage
COPY --from=builder /usr/src/app/build ./build

# Expose port
EXPOSE 3000

# Start the application
CMD ["serve", "-s", "build", "-l", "3000"]
