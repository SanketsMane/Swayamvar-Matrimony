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

        $validator = \Validator::make($request->all(), [
            'first_name' => 'required',
            'last_name' => 'required',
            'gender' => 'required',
            'date_of_birth' => 'required|date',
            'on_behalf' => 'required',
            'package' => 'required',
            'phone' => 'required|unique:users',
            'email' => 'nullable|email|unique:users',
            // Basic fields from Phase 1
            'marital_status' => 'required',
            'language' => 'required',
            'photo' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:2048', // Added photo validation [Sanket]
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
            $user->email = $request->email;
            $user->phone = $request->phone;
            $user->mobile2 = $request->mobile2 ?? null;
            $user->gov_id_type = $request->gov_id_type ?? null;
            $user->gov_id_number = $request->gov_id_number ?? null;
            $user->password = \Hash::make($password);
            $user->telecaller_id = $telecaller->id; // Assign telecaller ID [Sanket]

            $user->save();

            // Handle optional profile picture [Sanket]
            if ($request->hasFile('photo')) {
                $photo = $request->file('photo');
                $filename = 'profile_' . $user->id . '_' . time() . '.' . $photo->getClientOriginalExtension();
                $path = $photo->storeAs('uploads/all', $filename, 'public');
                $user->photo = $path;
                $user->save(); // Save again with photo path
            }

            $package = \App\Models\Package::find($request->package);

            // --- Members Table ---
            $member = new \App\Models\Member;
            $member->user_id = $user->id;
            $member->gender = $request->gender;
            $member->on_behalves_id = $request->on_behalf;
            $member->marital_status_id = $request->marital_status; 
            $member->mothere_tongue = $request->language; 
            $member->birthday = date('Y-m-d', strtotime($request->date_of_birth));
            $member->children = $request->children ?? 0;
            $member->current_package_id = $package->id;
            $member->remaining_interest = $package->express_interest;
            $member->remaining_photo_gallery = $package->photo_gallery;
            $member->remaining_contact_view = $package->contact;
            $member->remaining_profile_image_view = $package->profile_image_view;
            $member->remaining_gallery_image_view = $package->gallery_image_view;
            $member->auto_profile_match = $package->auto_profile_match;
            $member->package_validity = Date('Y-m-d', strtotime($package->validity . " days"));
            $member->save();

            $user->membership = $package->id == 1 ? 1 : 2;
            $user->save();

            // Record Package Payment referencing the telecaller [Sanket]
            if ($package->price > 0) {
                $payment = new \App\Models\PackagePayment;
                $payment->payment_code = date('Ym') . rand(10, 99);
                $payment->user_id = $user->id;
                $payment->package_id = $package->id;
                $payment->amount = $package->price;
                $payment->payment_method = $request->payment_method ?? 'manual_cash';
                $payment->payment_status = 'Paid';
                $payment->telecaller_id = $telecaller->id;
                $payment->save();
            }

            // --- Physical Attributes ---
            if ($request->has('height') || $request->has('weight') || $request->has('blood_group') || $request->has('complexion') || $request->has('physical_disability')) {
                $physical = new \App\Models\PhysicalAttribute;
                $physical->user_id = $user->id;
                $physical->height = $request->height ?? null;
                $physical->weight = $request->weight ?? null;
                $physical->blood_group = $request->blood_group ?? null;
                $physical->complexion = $request->complexion ?? null;
                if ($request->has('physical_disability')) {
                    $physical->disability = $request->physical_disability;
                }
                $physical->disability_details = $request->disability_details ?? null;
                $physical->save();
            }

            // --- Spiritual Background ---
            if ($request->has('religion') || $request->has('caste') || $request->has('manglik') || $request->has('intercaste_accepted')) {
                $spiritual = new \App\Models\SpiritualBackground;
                $spiritual->user_id = $user->id;
                $spiritual->religion_id = $request->religion ?? null;
                $spiritual->caste_id = $request->caste ?? null;
                $spiritual->sub_caste_id = $request->sub_caste ?? null;
                if ($request->has('manglik')) {
                    $spiritual->manglik = $request->manglik == 'true' || $request->manglik == 1;
                }
                if ($request->has('intercaste_accepted')) {
                    $spiritual->intercaste_accepted = $request->intercaste_accepted == 'true' || $request->intercaste_accepted == 1;
                }
                $spiritual->save();
            }

            // --- Lifestyle ---
            if ($request->has('diet') || $request->has('drink') || $request->has('smoke')) {
                $lifestyle = new \App\Models\Lifestyle;
                $lifestyle->user_id = $user->id;
                $lifestyle->diet = $request->diet ?? null;
                $lifestyle->drink = $request->drink ?? null;
                $lifestyle->smoke = $request->smoke ?? null;
                $lifestyle->save();
            }

            // --- Family Details ---
            if ($request->has('father_alive') || $request->has('mother_alive') || $request->has('no_of_brothers') || $request->has('parents_occupation')) {
                $family = new \App\Models\Family;
                $family->user_id = $user->id;
                if ($request->has('father_alive')) {
                    $family->father_alive = ($request->father_alive == 'true' || $request->father_alive == 1);
                }
                if ($request->has('mother_alive')) {
                    $family->mother_alive = ($request->mother_alive == 'true' || $request->mother_alive == 1);
                }
                $family->no_of_brothers = $request->no_of_brothers ?? null;
                $family->married_brothers = $request->married_brothers ?? null;
                $family->no_of_sisters = $request->no_of_sisters ?? null;
                $family->married_sisters = $request->married_sisters ?? null;
                $family->father = $request->parents_occupation ?? null;
                $family->property_details = $request->property_details ?? null;
                $family->save();
            }

            // --- Education & Career ---
            if ($request->has('education_level')) {
                $education = new \App\Models\Education;
                $education->user_id = $user->id;
                $education->degree = $request->education_level;
                $education->present = 1;
                $education->save();
            }

            if ($request->has('occupation_type') || $request->has('occupation_details')) {
                $career = new \App\Models\Career;
                $career->user_id = $user->id;
                $career->designation = $request->occupation_type ?? null;
                $career->occupation_details = $request->occupation_details ?? null;
                $career->present = 1;
                $career->save();
            }

            // --- Address ---
            if ($request->has('country') || $request->has('address')) {
                $address = new \App\Models\Address;
                $address->user_id = $user->id;
                $address->type = 'present';
                $address->country_id = $request->country ?? null;
                $address->state_id = $request->state ?? null;
                $address->city_id = $request->city ?? null;
                $address->postal_code = $request->address ?? null;
                $address->save();
            }

            // --- Partner Expectations ---
            if ($request->has('partner_manglik') || $request->has('expected_education') || $request->has('divorce_accepted') || $request->has('partner_intercaste')) {
                $partner = new \App\Models\PartnerExpectation;
                $partner->user_id = $user->id;
                if ($request->has('partner_manglik')) {
                    $partner->manglik = ($request->partner_manglik == 'true' || $request->partner_manglik == 1);
                }
                $partner->education = $request->expected_education ?? null;
                if ($request->has('divorce_accepted')) {
                    $partner->divorce_accepted = ($request->divorce_accepted == 'true' || $request->divorce_accepted == 1);
                }
                if ($request->has('partner_intercaste')) {
                    $partner->intercaste_accepted = ($request->partner_intercaste == 'true' || $request->partner_intercaste == 1);
                }
                $partner->save();
            }

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
            }

            \DB::commit();

            return response()->json([
                'result' => true,
                'message' => 'Profile compiled successfully with 44 fields by telecaller',
                'user_id' => $user->id,
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
