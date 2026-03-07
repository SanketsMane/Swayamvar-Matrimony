#!/bin/bash
sshpass -p '!Jn$J!@0SA87Q5z8AAts' ssh -o StrictHostKeyChecking=no -p 22 root@91.99.127.245 << 'REMOTE'
cd /var/www/swayamvar
php artisan env
grep RENFLAIR .env
REMOTE
