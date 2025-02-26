#!/bin/sh

# Ensure BACKEND_URL is set
if [ -z "$BACKEND_URL" ]; then
  echo "ERROR: BACKEND_URL is not set!"
  exit 1
fi

echo "Setting BACKEND_URL to $BACKEND_URL"

# Replace the placeholder in nginx.conf dynamically
envsubst '$BACKEND_URL' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Replace environment variables in JS and CSS files (for Vite)
for i in $(env | grep MY_APP_); do
    key=$(echo $i | cut -d '=' -f 1)
    value=$(echo $i | cut -d '=' -f 2-)

    echo "Replacing $key in JS and CSS files..."
    find /usr/share/nginx/html -type f \( -name '*.js' -o -name '*.css' \) -exec sed -i "s|${key}|${value}|g" '{}' +
done

# Start Nginx
exec nginx -g "daemon off;"
