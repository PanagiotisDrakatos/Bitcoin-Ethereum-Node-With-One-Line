FROM node:24 as builder
WORKDIR /workspace
RUN apt-get update && apt-get install -y cron
COPY . .
RUN npm install

# No need to run or install crontab/cron in the builder stage

FROM node:24-alpine
WORKDIR /workspace
COPY --from=builder /workspace .
RUN apk --no-cache add git dcron

# Copy your crontab file to the right location
COPY my-crontab /etc/cron.d/my-crontab
RUN chmod 0644 /etc/cron.d/my-crontab

# Optional: install the crontab for root user
RUN crontab /etc/cron.d/my-crontab
# Start both cron and your Node.js app
CMD crond && npm start

EXPOSE 3002