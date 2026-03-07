#!/bin/bash
export SSHPASS='!Jn$J!@0SA87Q5z8AAts'
IP="91.99.127.245"

echo "Syncing application code (Backend + Flutter)..."
# Use rsync to sync only code, excluding environment-specific, heavy, and build directories
sshpass -e rsync -avz --exclude='node_modules' --exclude='.git' --exclude='storage' --exclude='vendor' --exclude='.env' --exclude='*.exp' --exclude='*.sql' --exclude='build' --exclude='.dart_tool' ./ root@$IP:/var/www/swayamvar/

echo "Optimizing application and fixing permissions on remote server..."
# Fix permissions: Directories 755, Files 644, and set owner to www-data
sshpass -e ssh -o StrictHostKeyChecking=no root@$IP "
    chown -R www-data:www-data /var/www/swayamvar &&
    find /var/www/swayamvar -type d -exec chmod 755 {} \; &&
    find /var/www/swayamvar -type f -exec chmod 644 {} \; &&
    chmod +x /var/www/swayamvar/artisan &&
    cd /var/www/swayamvar && 
    php artisan optimize:clear && 
    php artisan cache:clear && 
    chown -R www-data:www-data /var/www/swayamvar/storage /var/www/swayamvar/bootstrap/cache
"

echo "Deployment complete."
