#!/bin/bash

echo "curl is not installed. Installing..."
sudo apt-get update
sudo apt-get install -y curl

echo "jq is not installed. Installing..."
sudo apt-get update
sudo apt-get install -y jq


# Check if a user ID parameter is provided
if [ -z "$1" ]; then
    exit 1
fi

user_id="$1"

# API endpoint
api_url="https://reqres.in/api/users/$user_id"

# Fetch user data and save as JSON
response=$(curl -s "$api_url")
user_firstname=$(echo "$response" | jq -r '.data.first_name')
user_lastname=$(echo "$response" | jq -r '.data.last_name')
user_avatar_url=$(echo "$response" | jq -r '.data.avatar')

json_filename="user_${user_id}_${user_firstname}_${user_lastname}.json"
avatar_filename="user_${user_id}_$(basename "$user_avatar_url")"

# Download JSON data
echo "$response" > "$json_filename"
echo "JSON data saved as $json_filename"

# Download avatar image
curl -s -o "$avatar_filename" "$user_avatar_url"
echo "Avatar image saved as $avatar_filename"
