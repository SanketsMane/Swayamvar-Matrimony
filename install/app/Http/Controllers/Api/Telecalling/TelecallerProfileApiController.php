<?php

namespace App\Http\Controllers\Api\Telecalling;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Auth;

class TelecallerProfileApiController extends Controller
{
    public function getProfile(Request $request)
    {
        $user = Auth::user();
        
        if (!$user) {
             return response()->json(['result' => false, 'message' => 'User not found'], 404);
        }

        return response()->json([
            'result' => true,
            'user' => [
                'id' => $user->id,
                'name' => $user->first_name . ' ' . $user->last_name,
                'email' => $user->email,
                'phone' => $user->phone,
                'status' => $user->blocked == 1 ? 'Blocked' : 'Active',
                'joined_at' => $user->created_at ? $user->created_at->format('M d, Y') : 'Unknown',
            ]
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'result' => true,
            'message' => 'Logged out successfully'
        ]);
    }

    // Sanket: Allows a telecaller to change their own password securely
    public function changePassword(Request $request)
    {
        $user = Auth::user();

        $validator = \Validator::make($request->all(), [
            'current_password'       => 'required',
            'new_password'           => 'required|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'result'  => false,
                'message' => $validator->errors()->first(),
            ], 422);
        }

        // Verify current password before allowing change
        if (!\Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'result'  => false,
                'message' => 'Current password is incorrect.',
            ], 403);
        }

        $user->password = \Hash::make($request->new_password);
        $user->save();

        return response()->json([
            'result'  => true,
            'message' => 'Password updated successfully.',
        ]);
    }

    public function getDropdownData()
    {
        $educations = \App\Models\Education::select('id', 'degree as name')->distinct()->get();
        if ($educations->isEmpty()) {
            $educations = [
                ['id' => '10th Std', 'name' => '10th Std'],
                ['id' => '12th Std (HSC)', 'name' => '12th Std (HSC)'],
                ['id' => 'Diploma', 'name' => 'Diploma'],
                ['id' => 'B.A', 'name' => 'B.A'],
                ['id' => 'B.Com', 'name' => 'B.Com'],
                ['id' => 'B.Sc', 'name' => 'B.Sc'],
                ['id' => 'B.Tech / B.E', 'name' => 'B.Tech / B.E'],
                ['id' => 'B.C.A', 'name' => 'B.C.A'],
                ['id' => 'M.A', 'name' => 'M.A'],
                ['id' => 'M.Com', 'name' => 'M.Com'],
                ['id' => 'M.Sc', 'name' => 'M.Sc'],
                ['id' => 'M.Tech / M.E', 'name' => 'M.Tech / M.E'],
                ['id' => 'M.C.A', 'name' => 'M.C.A'],
                ['id' => 'MBA', 'name' => 'MBA'],
                ['id' => 'PhD', 'name' => 'PhD'],
            ];
        }

        $payment_methods = \App\Models\ManualPaymentMethod::select('id', 'heading as name')->get();
        if ($payment_methods->isEmpty()) {
            $payment_methods = [
                ['id' => 'manual_cash', 'name' => 'Cash Payment'],
                ['id' => 'manual_bank', 'name' => 'Bank Transfer / NEFT'],
                ['id' => 'manual_upi', 'name' => 'UPI (GPay / PhonePe)'],
            ];
        }

        return response()->json([
            'result' => true,
            'data' => [
                'genders' => [
                    ['id' => 'Male', 'name' => 'Male'],
                    ['id' => 'Female', 'name' => 'Female']
                ],
                'on_behalves' => \App\Models\OnBehalf::select('id', 'name')->get(),
                'marital_statuses' => \App\Models\MaritalStatus::select('id', 'name')->get(),
                'religions' => \App\Models\Religion::select('id', 'name')->get(),
                'castes' => \App\Models\Caste::select('id', 'name', 'religion_id')->get(),
                'sub_castes' => \App\Models\SubCaste::select('id', 'name', 'caste_id')->get(),
                'languages' => \App\Models\MemberLanguage::select('id', 'name')->get(),
                'countries' => \App\Models\Country::select('id', 'name')->get(),
                'packages' => \App\Models\Package::where('active', 1)->select('id', 'name', 'price')->get(),
                // Added new dropdowns for the 44 fields UI
                'family_values' => \App\Models\FamilyValue::select('id', 'name')->get(),
                'blood_groups' => [
                    ['id' => 'A+', 'name' => 'A+'], ['id' => 'A-', 'name' => 'A-'],
                    ['id' => 'B+', 'name' => 'B+'], ['id' => 'B-', 'name' => 'B-'],
                    ['id' => 'AB+', 'name' => 'AB+'], ['id' => 'AB-', 'name' => 'AB-'],
                    ['id' => 'O+', 'name' => 'O+'], ['id' => 'O-', 'name' => 'O-'],
                ],
                'complexions' => [
                    ['id' => 'Very Fair', 'name' => 'Very Fair'], ['id' => 'Fair', 'name' => 'Fair'],
                    ['id' => 'Wheatish', 'name' => 'Wheatish'], ['id' => 'Wheatish Brown', 'name' => 'Wheatish Brown'],
                    ['id' => 'Dark', 'name' => 'Dark'],
                ],
                'body_types' => [
                    ['id' => 'Slim', 'name' => 'Slim'], ['id' => 'Athletic', 'name' => 'Athletic'],
                    ['id' => 'Average', 'name' => 'Average'], ['id' => 'Heavy', 'name' => 'Heavy'],
                ],
                'diets' => [
                    ['id' => 'Vegetarian', 'name' => 'Vegetarian'], ['id' => 'Non-Vegetarian', 'name' => 'Non-Vegetarian'],
                    ['id' => 'Eggetarian', 'name' => 'Eggetarian'], ['id' => 'Vegan', 'name' => 'Vegan'],
                ],
                'educations' => $educations,
                'occupations' => \App\Models\Career::select('id', 'designation as name')->distinct()->get(),
                'heights' => [
                    ['id' => '4.5', 'name' => '4 ft 5 in'],
                    ['id' => '4.6', 'name' => '4 ft 6 in'],
                    ['id' => '4.7', 'name' => '4 ft 7 in'],
                    ['id' => '4.8', 'name' => '4 ft 8 in'],
                    ['id' => '4.9', 'name' => '4 ft 9 in'],
                    ['id' => '5.0', 'name' => '5 ft 0 in'],
                    ['id' => '5.1', 'name' => '5 ft 1 in'],
                    ['id' => '5.2', 'name' => '5 ft 2 in'],
                    ['id' => '5.3', 'name' => '5 ft 3 in'],
                    ['id' => '5.4', 'name' => '5 ft 4 in'],
                    ['id' => '5.5', 'name' => '5 ft 5 in'],
                    ['id' => '5.6', 'name' => '5 ft 6 in'],
                    ['id' => '5.7', 'name' => '5 ft 7 in'],
                    ['id' => '5.8', 'name' => '5 ft 8 in'],
                    ['id' => '5.9', 'name' => '5 ft 9 in'],
                    ['id' => '6.0', 'name' => '6 ft 0 in'],
                    ['id' => '6.1', 'name' => '6 ft 1 in'],
                    ['id' => '6.2', 'name' => '6 ft 2 in'],
                    ['id' => '6.3', 'name' => '6 ft 3 in'],
                    ['id' => '6.4', 'name' => '6 ft 4 in'],
                    ['id' => '6.5', 'name' => '6 ft 5 in'],
                ],
                'manual_payment_methods' => $payment_methods,
            ]
        ]);
    }

    public function getStates($country_id)
    {
        $states = \App\Models\State::where('country_id', $country_id)->select('id', 'name')->get();
        return response()->json([
            'result' => true,
            'data' => $states
        ]);
    }

    public function getCities($state_id)
    {
        $cities = \App\Models\City::where('state_id', $state_id)->select('id', 'name')->get();
        return response()->json([
            'result' => true,
            'data' => $cities
        ]);
    }

    public function storeProfile(Request $request)
    {
        $telecaller = Auth::user();

        // New streamlined 8-step validation
        $validator = \Validator::make($request->all(), [
            // 1. Personal
            'first_name' => 'required',
            'last_name' => 'required',
            'gender' => 'required',
            'date_of_birth' => 'required|date',
            'religion' => 'required',
            'caste' => 'required',
            'sub_caste' => 'nullable',
            'marital_status' => 'required',
            
            // 2. Physical
            'height' => 'required',
            'weight' => 'nullable',
            'blood_group' => 'required',
            'complexion' => 'required',
            'physical_disability' => 'required',
            'diet' => 'nullable',
            'manglik' => 'required',
            'intercaste_accepted' => 'required',

            // 3. Family
            'father_alive' => 'required',
            'mother_alive' => 'required',
            'no_of_brothers' => 'required|numeric',
            'married_brothers' => 'nullable|numeric|lte:no_of_brothers',
            'no_of_sisters' => 'required|numeric',
            'married_sisters' => 'nullable|numeric|lte:no_of_sisters',
            'parents_occupation' => 'nullable',
            'property_details' => 'nullable',

            // 4. Education
            'education_level' => 'required',

            // 5. Career
            'occupation_type' => 'required',
            'occupation_details' => 'required',
            'annual_income' => 'required',

            // 6. Contact
            'phone' => 'required|digits:10|unique:users',
            'mobile2' => 'nullable|digits:10',

            // 7. Address
            'gov_id_type' => 'required',
            'gov_id_number' => 'required|unique:users',
            'address' => 'required',
            'state' => 'required',
            'district' => 'required', // Mapped to City ID eventually
            'city' => 'nullable',

            // 8. Photo
            'photo' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'result' => false,
                'message' => $validator->errors()->first(),
                'errors' => $validator->errors()
            ], 422);
        }

        \DB::beginTransaction();
        try {
            $password = \Str::random(8);

            // --- Users Table Details ---
            $user = new \App\Models\User;
            $user->user_type = 'member';
            $user->code = unique_code();
            $user->first_name = $request->first_name;
            $user->middle_name = $request->middle_name ?? null;
            $user->last_name = $request->last_name;
            // Removed email requirement from UI, using placeholder or null
            $user->email = $request->email ?? null;
            $user->phone = $request->phone;
            $user->mobile2 = $request->mobile2 ?? null;
            $user->gov_id_type = $request->gov_id_type;
            $user->gov_id_number = $request->gov_id_number;
            $user->password = \Hash::make($password);
            $user->telecaller_id = $telecaller->id; // Assign telecaller ID [Sanket]
            $user->membership = 1; // Default Free Package

            $user->save();

            // Handle optional profile picture (Step 8) [Sanket]
            if ($request->hasFile('photo')) {
                $user->photo = upload_api_file($request->file('photo'));
                $user->save();
            }

            // Default Free Package Implicit Logic
            $package_id = 1; // ID 1 is typically the Free package
            $package = \App\Models\Package::find($package_id);
            
            // Assume "Myself" for on_behalf (ID 1 usually)
            $on_behalf_id = 1;

            // --- Members Table ---
            $member = new \App\Models\Member;
            $member->user_id = $user->id;
            $member->gender = $request->gender;
            $member->on_behalves_id = $on_behalf_id; // Implicit Default
            $member->marital_status_id = $request->marital_status; 
            // Default Mother Tongue to generic if omitted from 8 steps
            $member->mothere_tongue = $request->language ?? 1; 
            $member->birthday = date('Y-m-d', strtotime($request->date_of_birth));
            $member->children = 0; // Default
            
            if ($package) {
                $member->current_package_id = $package->id;
                $member->remaining_interest = $package->express_interest;
                $member->remaining_photo_gallery = $package->photo_gallery;
                $member->remaining_contact_view = $package->contact;
                $member->remaining_profile_image_view = $package->profile_image_view;
                $member->remaining_gallery_image_view = $package->gallery_image_view;
                $member->auto_profile_match = $package->auto_profile_match;
                $member->package_validity = Date('Y-m-d', strtotime($package->validity . " days"));
            }
            $member->save();

            // --- Physical Attributes (Step 2) ---
            $physical = new \App\Models\PhysicalAttribute;
            $physical->user_id = $user->id;
            $physical->height = $request->height;
            $physical->weight = $request->weight ?? null;
            $physical->blood_group = $request->blood_group;
            $physical->complexion = $request->complexion;
            $physical->disability = $request->physical_disability;
            $physical->save();
            
            // Save Diet in Lifestyle table if provided
            if ($request->has('diet') && !empty($request->diet)) {
                $lifestyle = new \App\Models\Lifestyle;
                $lifestyle->user_id = $user->id;
                $lifestyle->diet = $request->diet;
                $lifestyle->save();
            }

            // --- Spiritual Background (Step 1 & 2) ---
            $spiritual = new \App\Models\SpiritualBackground;
            $spiritual->user_id = $user->id;
            $spiritual->religion_id = $request->religion;
            $spiritual->caste_id = $request->caste;
            $spiritual->sub_caste_id = $request->sub_caste ?? null;
            $spiritual->manglik = ($request->manglik == 'Yes' || $request->manglik == 'true' || $request->manglik == '1' || $request->manglik == 1) ? 1 : 0;
            $spiritual->intercaste_accepted = ($request->intercaste_accepted == 'Yes' || $request->intercaste_accepted == 'true' || $request->intercaste_accepted == '1' || $request->intercaste_accepted == 1) ? 1 : 0;
            $spiritual->save();

            // --- Family Info (Step 3) ---
            $family = new \App\Models\Family;
            $family->user_id = $user->id;
            $father_alive = ($request->father_alive == 'Yes' || $request->father_alive == 'true' || $request->father_alive == '1' || $request->father_alive == 1);
            $family->father_alive = $father_alive ? 1 : 0;
            $family->father = $father_alive ? 'Alive' : 'Dead';
            
            $mother_alive = ($request->mother_alive == 'Yes' || $request->mother_alive == 'true' || $request->mother_alive == '1' || $request->mother_alive == 1);
            $family->mother_alive = $mother_alive ? 1 : 0;
            $family->mother = $mother_alive ? 'Alive' : 'Dead';
            
            $family->no_of_brothers = $request->no_of_brothers;
            $family->married_brothers = $request->married_brothers ?? 0;
            $family->no_of_sisters = $request->no_of_sisters;
            $family->married_sisters = $request->married_sisters ?? 0;
            $family->property_details = $request->property_details ?? null;
            $family->sibling = $request->parents_occupation ?? null; // using sibling for parent occupation as requested in simplified form
            $family->save();

            // --- Education (Step 4) ---
            $education = new \App\Models\Education;
            $education->user_id = $user->id;
            $education->degree = $request->education_level;
            $education->present = 1;
            $education->save();

            // --- Career (Step 5) ---
            $career = new \App\Models\Career;
            $career->user_id = $user->id;
            $career->designation = $request->occupation_type;
            $career->occupation_details = $request->occupation_details;
            $career->income = $request->annual_income;
            $career->present = 1;
            $career->save();

            // --- Address (Step 7) ---
            $address = new \App\Models\Address;
            $address->user_id = $user->id;
            $address->type = 'present';
            // Assuming India (101) by default for telecalling campaigns
            $address->country_id = 101; 
            $address->state_id = $request->state;
            $address->city_id = $request->district; // Storing district in city_id or mapping it if needed
            $address->postal_code = $request->address;
            $address->save();

            // Notification
            try {
                if ($user->email) {
                   \App\Utility\EmailUtility::account_oppening_email($user->id, $password);
                }
                if ($user->phone) {
                   \App\Utility\SmsUtility::account_opening_by_admin($user, $password);
                }
            } catch (\Throwable $e) {}

            // Send notification to admin [Sanket]
            $admins = \App\Models\User::where('user_type', 'admin')->get();
            foreach($admins as $admin) {
                // System notification for biodata creation
                $notification = new \App\Models\Notification;
                $notification->id = unique_notify_id();
                $notification->type = 'App\Notifications\TelecallerBiodataCreated';
                $notification->notifiable_type = 'App\Models\User';
                $notification->notifiable_id = $admin->id;
                $notification->data = json_encode([
                    'type' => 'telecaller_biodata_created',
                    'title' => 'New Biodata Entry',
                    'message' => ($telecaller->first_name ?? 'Admin') . ' created a new profile for: ' . $user->first_name,
                    'url' => route('members.show', encrypt($user->id))
                ]);
                $notification->save();
                
                // Email notification for biodata creation
                try {
                    if (get_email_template('account_opening_email_to_admin', 'status')) {
                        \App\Utility\EmailUtility::account_opening_email_to_admin($user, $admin);
                    }
                } catch (\Throwable $e) {}
            }
            
            // Payment Notification to admin [Sanket]
            if ($package->price > 0 && isset($payment)) {
                try {
                    $notify_type = 'package_purchase';
                    $id = unique_notify_id();
                    $notify_by = $user->id;
                    $info_id = $payment->id;
                    
                    $methodName = $payment->payment_method == 'manual_payment' ? $payment->custom_payment_name : $payment->payment_method;
                    $message = ($telecaller->first_name ?? 'Telecaller') . ' collected payment (' . $methodName . ') from ' . $user->first_name . ' for package ' . $package->name;
                    $route = route('package-payments.index');

                    foreach($admins as $admin) {
                        \Notification::send($admin, new \App\Notifications\DbStoreNotification($notify_type, $id, $notify_by, $info_id, $message, $route));
                    }
                } catch (\Exception $e) {}
            }

            \DB::commit();

            return response()->json([
                'result' => true,
                'message' => 'Profile compiled successfully with 44 fields by telecaller',
                'user_id' => $user->id,
                'matrimony_id' => $user->code, // Added matrimony_id [Sanket]
                'temporary_password' => $password
            ]);

        } catch (\Exception $e) {
            \DB::rollBack();
            return response()->json([
                'result' => false,
                'message' => 'Failed to create profile: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getMyProfiles(Request $request)
    {
        $telecaller = Auth::user();
        $query = \App\Models\User::where('user_type', 'member')
                                 ->where('telecaller_id', $telecaller->id)
                                 ->with('member.package');

        if ($request->has('search') && $request->search != '') {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('first_name', 'like', "%{$search}%")
                  ->orWhere('last_name', 'like', "%{$search}%")
                  ->orWhere('code', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%");
            });
        }

        $profiles = $query->orderBy('created_at', 'desc')->paginate(15);

        return response()->json([
            'result' => true,
            'data'   => $profiles->items(),
            'current_page' => $profiles->currentPage(),
            'last_page' => $profiles->lastPage(),
            'total' => $profiles->total(),
        ]);
    }

    // Sanket: Returns the last 30 notifications for the authenticated telecaller
    public function getNotifications(Request $request)
    {
        $user = Auth::user();

        $notifications = \App\Models\Notification::where('notifiable_id', $user->id)
            ->where('notifiable_type', 'App\Models\User')
            ->latest()
            ->take(30)
            ->get()
            ->map(function ($n) {
                $data = is_string($n->data) ? json_decode($n->data, true) : (array) $n->data;
                return [
                    'id'         => $n->id,
                    'title'      => $data['title'] ?? 'Notification',
                    'message'    => $data['message'] ?? '',
                    'type'       => $data['type'] ?? 'general',
                    'read_at'    => $n->read_at,
                    'created_at' => $n->created_at,
                ];
            });

        return response()->json([
            'result' => true,
            'data'   => $notifications,
        ]);
    }
}
