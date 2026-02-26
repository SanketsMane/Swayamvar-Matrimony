<?php
$content = file_get_contents('routes/admin.php');
$content = preg_replace("/Route::get\('(.*)\/destroy\/{id}',\s*(.*)\)->name\('(.*?\.destroy)'\);/", "Route::get('$1/destroy/{id}', $2)->name('$3_get');", $content);
file_put_contents('routes/admin.php', $content);
echo "Fixed routes/admin.php\n";
