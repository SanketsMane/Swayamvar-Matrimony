<?php
// cleanup_dummy_data.php
// Created by Sanket

require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\User;
use App\Models\Member;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

echo "Starting dummy data cleanup...\n";

// 1. Identify member users
$memberUsers = User::where('user_type', 'member')->get();
$memberUserIds = $memberUsers->pluck('id')->toArray();

if (empty($memberUserIds)) {
    echo "No dummy members found.\n";
} else {
    echo "Found " . count($memberUserIds) . " dummy members. Deleting related data...\n";

    // Tables that use 'user_id'
    $tablesWithUserId = [
        'addresses', 'astrologies', 'attitudes', 'careers', 'education', 
        'families', 'hobbies', 'lifestyles', 'physical_attributes', 
        'spiritual_backgrounds', 'partner_expectations', 'happy_stories',
        'notifications', 'ignored_users', 'shortlists', 'reported_users', 
        'profile_matches', 'package_payments', 'view_contacts', 
        'view_gallery_images', 'view_profile_pictures'
    ];

    foreach ($tablesWithUserId as $table) {
        if (Schema::hasTable($table)) {
            try {
                $count = DB::table($table)->whereIn('user_id', $memberUserIds)->delete();
                echo "- Deleted $count records from $table.\n";
            } catch (\Exception $e) {
                echo "! Error deleting from $table: " . $e->getMessage() . "\n";
            }
        }
    }

    // Chat threads - uses sender_user_id or receiver_user_id
    if (Schema::hasTable('chat_threads')) {
        $count = DB::table('chat_threads')
            ->whereIn('sender_user_id', $memberUserIds)
            ->orWhereIn('receiver_user_id', $memberUserIds)
            ->delete();
        echo "- Deleted $count records from chat_threads.\n";
    }

    // Chats - uses sender_user_id
    if (Schema::hasTable('chats')) {
        $count = DB::table('chats')->whereIn('sender_user_id', $memberUserIds)->delete();
        echo "- Deleted $count records from chats.\n";
    }

    // 3. Clear Members
    $count = Member::whereIn('user_id', $memberUserIds)->delete();
    echo "- Deleted $count records from members table.\n";

    // 4. Delete Users
    $count = User::whereIn('id', $memberUserIds)->forceDelete();
    echo "- Deleted $count member users.\n";
}

// 5. Clear Blogs
if (Schema::hasTable('blogs')) {
    $count = DB::table('blogs')->count();
    if ($count > 0) {
        DB::table('blogs')->truncate();
        echo "Cleared $count dummy blogs.\n";
    }
}

// 6. Clear Happy Stories (if any left)
if (Schema::hasTable('happy_stories')) {
    $count = DB::table('happy_stories')->count();
    if ($count > 0) {
        DB::table('happy_stories')->truncate();
        echo "Cleared $count dummy happy stories.\n";
    }
}

echo "Cleanup completed successfully!\n";
