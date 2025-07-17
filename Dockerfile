FROM node:18 AS build
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn  --network_timeout 300000 

COPY . .
RUN yarn build

FROM nginx:alpine AS prod
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN apk add --no-cache curl

HEALTHCHECK CMD curl -f http://localhost:8080/health || exit 1
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

