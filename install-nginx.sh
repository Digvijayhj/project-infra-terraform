#!/bin/bash
sudo apt update -y
sudo apt install nginx unzip -y
cd /var/www/html
echo "<h1>Vite App Placeholder</h1>" > index.html
