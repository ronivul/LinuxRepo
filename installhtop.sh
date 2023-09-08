#!/bin/bash

# Create log file
log_file="$(dirname "$0")/install.log"
echo "Logging installation details to: $log_file"
echo "----about Installing htop..." $(date) >> "$log_file"

# Print update repo message to log
echo "----updating Repo..." >> "$log_file"

# Update Linux packages cache
sudo apt update >> "$log_file" 2>&1

# Print htop installing details to log
echo "----htop installing details:" >> "$log_file"
apt show htop >> "$log_file" 2>&1

# Install htop and print version to log
sudo apt install -y htop >> "$log_file" 2>&1
installed_version=$(htop --version | head -n 1 | cut -d ' ' -f 2)
echo "---- htop installed with version: $installed_version" >> "$log_file"

# Get htop installed directory
htop_install_dir=$(which htop)
echo "htop installed directory: $htop_install_dir" >> "$log_file"

# Print running htop message to log
echo "----Running htop..." $(date) >> "$log_file"

# Run htop and capture its output to log and terminal
htop >> "$log_file" 2>&1

# Save htop terminal screen as htop.html using aha
sudo apt install -y aha >> "$log_file" 2>&1
script -q -c "htop" /dev/null | aha --black --line-fix > "$(dirname "$0")/htop.html"

echo "Installation and htop usage details saved in '$log_file'"
echo "htop terminal screen saved as 'htop.html'"
