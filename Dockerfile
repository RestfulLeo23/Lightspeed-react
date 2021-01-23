# multistage - builder image
FROM node:alpine AS builder

WORKDIR /app/Lightspeed-react
COPY . .

RUN npm install
RUN npm run build

# runtime image
FROM nginx:stable
COPY --from=builder /app/Lightspeed-react/build /usr/share/nginx/html

ENV WEB_RTC_ADDRESS $WEB_RTC_ADDRESS

CMD sed -i "s|stream.gud.software|$WEB_RTC_ADDRESS|g" /usr/share/nginx/html/config.json && exec nginx -g 'daemon off;'
