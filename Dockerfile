FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey_project"
COPY site/ /usr/share/nginx/html/

EXPOSE 80

