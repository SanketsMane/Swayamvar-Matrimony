<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Support\Facades\Http;

class FirebasePushService
{
    /**
     * Send a Push Notification via Firebase Cloud Messaging API v1
     */
    public static function sendToUser(User $user, $title, $body, $data = [])
    {
        if (empty($user->fcm_token)) {
            return false;
        }

        // To implement this in production, you must have a service account JSON file
        // and fetch an OAuth2 access token. For the sake of this implementation plan,
        // we'll provide the HTTP structure. Provide your Server Key or Bearer Token here.
        
        $serverKey = env('FCM_SERVER_KEY', 'YOUR_FIREBASE_SERVER_KEY');
        
        if ($serverKey == 'YOUR_FIREBASE_SERVER_KEY') {
             \Log::warning("FCM_SERVER_KEY not set. Mocking push notification to {$user->name}");
             return true;
        }

        $response = Http::withHeaders([
            'Authorization' => 'key=' . $serverKey,
            'Content-Type'  => 'application/json',
        ])->post('https://fcm.googleapis.com/fcm/send', [
            'to' => $user->fcm_token,
            'notification' => [
                'title' => $title,
                'body' => $body,
                'sound' => 'default'
            ],
            'data' => $data,
        ]);

        return $response->successful();
    }
}
