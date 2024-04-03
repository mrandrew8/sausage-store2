FROM node:16 as builder
WORKDIR /usr/src/app
copy . .
RUN npm install
RUN npm run build


#release
FROM nginx:latest
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html
COPY --from=builder /usr/src/app/nginx.tmpl /app/nginx.tmpl
EXPOSE 80 
# FROM nginx:stable-alpine3.17-slim
# WORKDIR /app
# COPY default.conf /etc/nginx/conf.d/default.conf
# COPY --from=builder /usr/src/app/dist/frontend ./frontend
# EXPOSE 80