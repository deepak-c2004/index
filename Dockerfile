FROM nginx:latest
WORKDIR /app
copy . /usr/share/nginx/html

