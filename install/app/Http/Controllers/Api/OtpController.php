<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class OtpController extends Controller
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
        $user = User::where('phone', $phone)->first();

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
        
        // Send OTP via SMS using configured provider (Renflair)
        sendSMS($user->phone, null, $text, $otp);

        return response()->json([
            'result' => true,
            'message' => 'OTP sent successfully'
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

        $user = User::where('phone', $request->phone)->where('verification_code', $request->otp)->first();

        if ($user) {
            $user->email_verified_at = Carbon::now();
            $user->verification_code = null; // Clear OTP after success
            $user->save();

            // Return success and user info for login
            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'result' => true,
                'message' => 'OTP verified successfully',
                'access_token' => $token,
                'token_type' => 'Bearer',
                'user' => [
                    'id' => $user->id,
                    'type' => $user->user_type,
                    'name' => $user->name,
                    'email' => $user->email,
                    'avatar' => uploaded_asset($user->photo),
                    'avatar_original' => static_asset($user->photo),
                    'phone' => $user->phone
                ]
            ]);
        }

        return response()->json([
            'result' => false,
            'message' => 'Invalid OTP'
        ]);
    }
}
