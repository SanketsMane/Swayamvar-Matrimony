<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "widget_mobile_app_title: " . get_setting('widget_mobile_app_title') . "\n";
echo "footer_play_store_link: " . get_setting('footer_play_store_link') . "\n";
echo "footer_app_store_link: " . get_setting('footer_app_store_link') . "\n";
echo "footer_play_store_img: " . get_setting('footer_play_store_img') . "\n";
echo "footer_app_store_img: " . get_setting('footer_app_store_img') . "\n";
