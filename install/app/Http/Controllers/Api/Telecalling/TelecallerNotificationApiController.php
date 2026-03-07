<?php

namespace App\Http\Controllers\Api\Telecalling;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Auth;

class TelecallerNotificationApiController extends Controller
{
    public function updateFcmToken(Request $request)
    {
        $request->validate([
            'fcm_token' => 'required|string',
        ]);

        $user = Auth::user();
        
        if ($user) {
            // Note: Make sure 'fcm_token' column exists in your users table.
            // For now, we assume it's added via migration.
            $user->fcm_token = $request->fcm_token;
            $user->save();

            return response()->json([
                'result' => true,
                'message' => 'FCM Token updated successfully'
            ]);
        }

        return response()->json([
            'result' => false,
            'message' => 'Unauthorized'
        ], 401);
    }
}
