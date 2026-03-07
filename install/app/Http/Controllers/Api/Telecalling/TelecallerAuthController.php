<?php

namespace App\Http\Controllers\Api\Telecalling;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\TelecallerDetail;
use Auth;
use Hash;
use Validator;

class TelecallerAuthController extends Controller
{
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'identity' => 'required',
            'password' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'result' => false,
                'message' => 'Please provide identity and password.',
                'errors' => $validator->errors()
            ], 422);
        }

        $identity = $request->identity;

        $user = User::where('user_type', 'telecaller')
                    ->where(function($query) use ($identity) {
                        $query->where('email', $identity)
                              ->orWhere('phone', $identity);
                    })->first();

        if ($user != null) {
            if (Hash::check($request->password, $user->password)) {

                if ($user->blocked == 1) {
                    return response()->json([
                        'result' => false,
                        'message' => 'User is blocked',
                        'user' => null
                    ], 403);
                }

                $tokenResult = $user->createToken('TelecallerAppToken');

                return response()->json([
                    'result' => true,
                    'message' => 'Successfully logged in',
                    'access_token' => $tokenResult->plainTextToken,
                    'token_type' => 'Bearer',
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->first_name . ' ' . $user->last_name,
                        'email' => $user->email,
                        'phone' => $user->phone,
                        'photo' => uploaded_asset($user->photo)
                    ]
                ]);
            } else {
                return response()->json([
                    'result' => false,
                    'message' => 'Invalid password.',
                    'user' => null
                ], 401);
            }
        } else {
            // Check if user exists but isn't a telecaller
            $anyUser = User::where('email', $identity)->orWhere('phone', $identity)->first();
            $msg = $anyUser ? 'Account exists but is not a telecaller.' : 'No account found with this email/phone.';
            
            return response()->json([
                'result' => false,
                'message' => $msg,
                'user' => null
            ], 404);
        }
    }

    // Stub for OTP sending (will be fully implemented if specific OTP provider is chosen)
    public function sendOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json(['result' => false, 'message' => 'Phone number required'], 422);
        }

        $user = User::where('phone', $request->phone)->where('user_type', 'telecaller')->first();
        if(!$user){
             return response()->json(['result' => false, 'message' => 'Telecaller not found with this number'], 404);
        }

        // TODO: Integrate actual SMS gateway logic here

        // For demo/development purpose
        $otp = '123456'; 
        return response()->json([
            'result' => true,
            'message' => 'OTP sent successfully (Demo: 123456)',
        ]);
    }

    public function verifyOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required',
            'otp' => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json(['result' => false, 'message' => 'Phone and OTP required'], 422);
        }

        // Demo OTP check
        if($request->otp === '123456') {
             $user = User::where('phone', $request->phone)->where('user_type', 'telecaller')->first();
             if($user){
                 $tokenResult = $user->createToken('TelecallerAppToken');
                 return response()->json([
                    'result' => true,
                    'message' => 'Successfully logged in with OTP',
                    'access_token' => $tokenResult->plainTextToken,
                    'token_type' => 'Bearer',
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->first_name . ' ' . $user->last_name,
                        'email' => $user->email,
                        'phone' => $user->phone,
                    ]
                ]);
             }
        }
        
        return response()->json(['result' => false, 'message' => 'Invalid OTP'], 401);
    }
}
