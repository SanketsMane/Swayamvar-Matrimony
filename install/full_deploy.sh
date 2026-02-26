#!/bin/bash
export SSHPASS='!Jn$J!@0SA87Q5z8AAts'
IP="91.99.127.245"

echo "Uploading database..."
sshpass -e scp -o StrictHostKeyChecking=no local_production_dump.sql root@$IP:/root/local_production_dump.sql

echo "Importing database..."
sshpass -e ssh -o StrictHostKeyChecking=no root@$IP "mysql -u swayamvar_user -p'Swayamvar@123' swayamvar < /root/local_production_dump.sql"

echo "Syncing application code..."
sshpass -e rsync -avz --exclude='node_modules' --exclude='.git' --exclude='storage' --exclude='vendor' --exclude='.env' --exclude='*.exp' --exclude='*.sql' ./ root@$IP:/var/www/swayamvar/

echo "Optimizing application..."
sshpass -e ssh -o StrictHostKeyChecking=no root@$IP "cd /var/www/swayamvar && php artisan optimize:clear && php artisan cache:clear && chown -R www-data:www-data /var/www/swayamvar/storage /var/www/swayamvar/bootstrap/cache"

echo "Deployment complete."
