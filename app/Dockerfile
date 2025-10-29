# Use lightweight nginx image
FROM nginx:alpine

# Copy our HTML file to nginx default directory
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
