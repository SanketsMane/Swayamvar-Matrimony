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
        if ($user->phone != null) {
            $text = "Your verification code is: " . $user->verification_code;
            // The sendSMS helper uses RENFLAIR_API_KEY from .env
            // For Renflair, the 4th parameter (template_id) is used as the OTP value in the API call
            sendSMS($user->phone, env('VALID_TWILLO_NUMBER'), $text, $user->verification_code);
        }
    }
}
