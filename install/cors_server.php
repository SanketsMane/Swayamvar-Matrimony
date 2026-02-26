<?php



// 1. Handle OPTIONS (Preflight)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    if (isset($_SERVER['HTTP_ORIGIN'])) {
        header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
        header('Access-Control-Allow-Credentials: true');
        header('Access-Control-Max-Age: 86400');    // cache for 1 day
    }
    
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
        header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE");         

    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
        header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");

    exit(0);
}

$uri = urldecode(
    parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH)
);

// 2. Handle Static Files
// We check both public folder (standard) and root
$file = null;
if ($uri !== '/' && file_exists(__DIR__.'/public'.$uri)) {
    $file = __DIR__.'/public'.$uri;
} elseif ($uri !== '/' && file_exists(__DIR__.$uri)) {
    $file = __DIR__.$uri;
}

if ($file) {
    // Add CORS headers for static files
    file_put_contents("php://stderr", "Serving File: $file\n");
    if (isset($_SERVER['HTTP_ORIGIN'])) {
        header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
        header('Access-Control-Allow-Credentials: true');
    }
    
    // Serve the file manually to ensure headers are sent
    // (Returning false causes the built-in server to serve it, but might drop headers)
    $mime = mime_content_type($file);
    file_put_contents("php://stderr", "MIME: $mime\n");

    header("Content-Type: $mime");
    header("Content-Length: " . filesize($file));
    readfile($file);
    exit;
} else {
    file_put_contents("php://stderr", "File Not Found for URI: $uri\n");
}

// 3. Handle Dynamic Requests (API/Web) - Pass to Laravel
// Do NOT add headers here, as Laravel's middleware handles it.
require_once __DIR__.'/index.php';
