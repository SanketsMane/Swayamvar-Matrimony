#!/bin/bash
sshpass -p '!Jn$J!@0SA87Q5z8AAts' ssh -o StrictHostKeyChecking=no -p 22 root@91.99.127.245 << 'REMOTE'
cd /var/www/swayamvar/install
git pull origin common
cd /var/www/swayamvar
cp install/app/Http/Helpers.php app/Http/Helpers.php
cp install/app/Http/Controllers/Api/OtpController.php app/Http/Controllers/Api/OtpController.php
cp install/routes/api.php routes/api.php
php artisan route:clear
php artisan cache:clear
php artisan config:clear
php artisan optimize:clear
REMOTE
