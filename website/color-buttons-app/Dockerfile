FROM node:20-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy app code
COPY . .

# Expose port
EXPOSE 3000

# Run app
CMD ["npm", "start"]
