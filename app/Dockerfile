
# Use a base image with Flutter pre-installed
FROM ghcr.io/cirruslabs/flutter:3.27.0

WORKDIR /app

# Copy the Flutter project files
COPY . .

# Get Flutter dependencies
RUN flutter pub get

# Build argument for API base URL
ARG API_BASE_URL

# Replace the placeholder with the actual API base URL
RUN find . -type f -name "*.dart" -exec sed -i "s|http://YOUR_API_HOST:8080/api|$API_BASE_URL|g" {} +

# Build the Flutter web application
RUN flutter build web --release

# Use Nginx to serve the Flutter web app
FROM nginx:alpine
COPY --from=0 /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
