#!/bin/bash
export SSHPASS='!Jn$J!@0SA87Q5z8AAts'
IP="91.99.127.245"

echo "Running safe optimization..."
sshpass -e ssh -o StrictHostKeyChecking=no root@$IP "cd /var/www/swayamvar && php artisan optimize:clear && php artisan config:cache && php artisan view:cache && chown -R www-data:www-data /var/www/swayamvar/storage /var/www/swayamvar/bootstrap/cache"
echo "Deployment finalized natively."
