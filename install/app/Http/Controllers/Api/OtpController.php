<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class OtpController extends AuthController
{
    public function sendOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'result' => false,
                'message' => 'Phone number is required'
            ]);
        }

        $phone = $request->phone;
        $clean_phone = ltrim($phone, '0'); // Remove leading zero if any

        $user = User::where('phone', $phone)
                    ->orWhere('phone', 'like', '%' . $clean_phone)
                    ->first();

        if (!$user) {
            return response()->json([
                'result' => false,
                'message' => 'User not found with this phone number'
            ]);
        }

        $otp = rand(100000, 999999);
        $user->verification_code = $otp;
        $user->save();

        $text = "Your OTP for Swayamvar Matrimony is: " . $otp;
        
        // This helper function uses the active SMS provider configured in settings
        $sms_response = sendSMS($user->phone, env('VALID_TWILLO_NUMBER'), $text, $otp);

        return response()->json([
            'result' => true,
            'message' => 'OTP sent successfully',
            'sms_response' => $sms_response
        ]);
    }

    public function verifyOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required',
            'otp' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'result' => false,
                'message' => 'Phone and OTP are required'
            ]);
        }

        $phone = $request->phone;
        $clean_phone = ltrim($phone, '0');

        $user = User::where(function($query) use ($phone, $clean_phone) {
            $query->where('phone', $phone)
                  ->orWhere('phone', 'like', '%' . $clean_phone);
        })->where('verification_code', $request->otp)->first();

        if ($user) {
            $user->verification_code = null; // Clear OTP after success
            $user->save();

            // Return success and user info for login
            return $this->authResponse($user);
        }

        return response()->json([
            'result' => false,
            'message' => 'Invalid OTP'
        ]);
    }
}
