<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class OTPVerificationController extends Controller
{
    /**
     * Send verification code via SMS
     * 
     * @param \App\Models\User $user
     * @return void
     */
    public function send_code(User $user)
    {
        // Ensure we have the latest data from DB
        $user->refresh();
        
        \Log::info("Sanket: OTPVerificationController@send_code for user ID: " . $user->id . " Code: [" . $user->verification_code . "]");

        if ($user->phone != null && !empty($user->verification_code)) {
            $text = "Your verification code is: " . $user->verification_code;
            sendSMS($user->phone, env('VALID_TWILLO_NUMBER'), $text, $user->verification_code);
        } else {
            \Log::warning("Sanket: Skipping SMS because phone is null or verification_code is empty. Phone: " . $user->phone);
        }
    }
}
