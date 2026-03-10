<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ActiveLead;
use App\Models\TelecallingCallLog;
use App\Models\TelecallingFollowup;
use App\Models\InactiveLead;
use App\Models\User;
use Auth;

class TelecallingDashboardController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:telecalling_dashboard']);
    }

    public function index()
    {
        if (Auth::user()->user_type == 'admin' || Auth::user()->user_type == 'staff') {
             // If has telecalling_reports, show admin dashboard stats [Sanket]
             if (Auth::user()->can('telecalling_reports')) {
                 return $this->admin_index();
             }
        }

        $user_id = Auth::id();
        
        // Stats for Agent [Sanket]
        $data['total_assigned'] = ActiveLead::where('assigned_to', $user_id)->count();
        $data['pending_calls'] = ActiveLead::where('assigned_to', $user_id)->where('status', '!=', 'Called')->count();
        $data['completed_calls'] = TelecallingCallLog::where('agent_id', $user_id)->count();
        $data['today_followups'] = TelecallingFollowup::where('agent_id', $user_id)
            ->whereDate('followup_date', date('Y-m-d'))
            ->count();

        $data['today_followups_list'] = TelecallingFollowup::where('agent_id', $user_id)
            ->whereDate('followup_date', date('Y-m-d'))
            ->with('lead')
            ->get();

        // Agent Commission Stats [Sanket]
        $telecaller_details = \App\Models\TelecallerDetail::where('user_id', $user_id)->first();
        $data['coupon_code'] = $telecaller_details ? $telecaller_details->coupon_code : null;
        $data['commission_percent'] = $telecaller_details ? $telecaller_details->commission_percent : 0;
        $data['total_commission'] = \App\Models\TelecallerCouponUsage::where('telecaller_id', $user_id)->sum('commission_amount');

        // Chart Data (Last 7 Days) [Sanket]
        $chart_dates = [];
        $chart_calls = [];
        for ($i = 6; $i >= 0; $i--) {
            $date = date('Y-m-d', strtotime("-$i days"));
            $chart_dates[] = date('d M', strtotime($date));
            $chart_calls[] = TelecallingCallLog::where('agent_id', $user_id)->whereDate('call_time', $date)->count();
        }
        $data['chart_dates'] = json_encode($chart_dates);
        $data['chart_calls'] = json_encode($chart_calls);

        // Recent leads
        $recent_leads = ActiveLead::where('assigned_to', $user_id)
            ->latest()
            ->limit(5)
            ->get();

        return view('admin.telecalling.dashboard.index', compact('data', 'recent_leads'));
    }

    public function assigned_leads(Request $request)
    {
        $user_id = Auth::id();
        $leads = ActiveLead::where('assigned_to', $user_id);

        if ($request->has('status')){
            $leads = $leads->where('status', $request->status);
        }

        $leads = $leads->latest()->paginate(15);
        return view('admin.telecalling.dashboard.assigned_leads', compact('leads'));
    }

    public function update_lead_action(Request $request)
    {
        $request->validate([
            'lead_id' => 'required',
            'status' => 'required',
        ]);

        $lead = ActiveLead::findOrFail($request->lead_id);
        $user_id = Auth::id();

        // 1. Create Call Log [Sanket]
        TelecallingCallLog::create([
            'lead_id' => $lead->id,
            'lead_type' => 'active_lead',
            'agent_id' => $user_id,
            'status' => $request->status,
            'notes' => $request->notes,
            'duration' => $request->duration,
            'call_time' => now(),
        ]);

        // 2. Schedule Follow-up if exists [Sanket]
        if ($request->followup_date) {
            TelecallingFollowup::updateOrCreate(
                ['lead_id' => $lead->id],
                [
                    'agent_id' => $user_id,
                    'followup_date' => $request->followup_date,
                    'notes' => $request->followup_notes,
                    'status' => 'pending'
                ]
            );
        }

        // 3. Update Lead Status [Sanket]
        if ($request->status == 'Not Interested' || $request->status == 'Closed') {
            // Logic to move to inactive if needed or just update status
            // For now, let's keep it in active with status update
            $lead->update(['status' => $request->status]);
        } else {
            $lead->update(['status' => $request->status]);
        }

        flash(translate('Call action updated successfully'))->success();
        return back();
    }

    // Sanket: Web Panel Fill Biodata Form
    public function fillBiodata()
    {
        // Load necessary data for dropdowns (match standard matrimony fields)
        $genders = [['id' => 'Male', 'name' => 'Male'], ['id' => 'Female', 'name' => 'Female']];
        $on_behalves = \App\Models\OnBehalf::all();
        $religions = \App\Models\Religion::all();
        $castes = \App\Models\Caste::all();
        $sub_castes = \App\Models\SubCaste::all();
        $marital_statuses = \App\Models\MaritalStatus::all();
        $languages = \App\Models\MemberLanguage::all();
        $countries = \App\Models\Country::all();
        $packages = \App\Models\Package::where('active', 1)->get();

        return view('admin.telecalling.dashboard.fill_biodata', compact('genders', 'on_behalves', 'religions', 'castes', 'sub_castes', 'marital_statuses', 'languages', 'countries', 'packages'));
    }

    // Sanket: Process Web Panel Fill Biodata Submit
    public function storeBiodata(Request $request)
    {
        $request->validate([
            'first_name' => 'required|string|max:225',
            'last_name' => 'required|string|max:225',
            'phone' => 'required|string|max:20',
            'gender' => 'required',
            'date_of_birth' => 'required|date',
            'package' => 'required'
        ]);

        $package = \App\Models\Package::find($request->package);
        if (!$package) {
            flash(translate('Invalid package selected.'))->error();
            return back();
        }

        return \DB::transaction(function () use ($request, $package) {
            $user_id = Auth::id(); // Telecaller ID

            // 1. Create User
            $user = new User;
            $user->user_type = 'member';
            // Unique code generator logic from project
            $user->code = unique_code();
            $user->first_name = $request->first_name;
            $user->last_name = $request->last_name;
            $user->password = \Hash::make('12345678');
            $user->phone = $request->phone;
            $user->email = $request->email;
            $user->telecaller_id = $user_id; // Tag with telecaller who filled it
            $user->save();

            // 2. Create Member Profile
            $member = new \App\Models\Member;
            $member->user_id = $user->id;
            $member->gender = $request->gender;
            $member->on_behalves_id = $request->on_behalf;
            $member->marital_status_id = $request->marital_status; // Sanket: added marital status
            $member->mothere_tongue = $request->language; // Sanket: added language
            $member->birthday = $request->date_of_birth;
            $member->save();

            // 3. Optional Sub-Models [Sanket]
            if ($request->has('religion') || $request->has('caste')) {
                $spiritual = new \App\Models\SpiritualBackground;
                $spiritual->user_id = $user->id;
                $spiritual->religion_id = $request->religion;
                $spiritual->caste_id = $request->caste;
                $spiritual->sub_caste_id = $request->sub_caste;
                $spiritual->save();
            }

            if ($request->has('height')) {
                $physical = new \App\Models\PhysicalAttribute;
                $physical->user_id = $user->id;
                $physical->height = $request->height;
                $physical->save();
            }

            if ($request->has('education')) {
                $education = new \App\Models\Education;
                $education->user_id = $user->id;
                $education->degree = $request->education;
                $education->present = 1;
                $education->save();
            }

            if ($request->has('occupation')) {
                $career = new \App\Models\Career;
                $career->user_id = $user->id;
                $career->designation = $request->occupation;
                $career->present = 1;
                $career->save();
            }

            if ($request->has('country')) {
                $address = new \App\Models\Address;
                $address->user_id = $user->id;
                $address->type = 'present';
                $address->country_id = $request->country;
                $address->state_id = $request->state;
                $address->city_id = $request->city;
                $address->save();
            }

            // 3. Record Package Payment
            if ($package && $package->price > 0) {
                $payment = new \App\Models\PackagePayment;
                $payment->user_id = $user->id;
                $payment->package_id = $package->id;
                $payment->amount = $package->price;
                $payment->payment_method = 'manual_cash';
                $payment->payment_status = 'Paid';
                $payment->telecaller_id = $user_id;
                $payment->save();
            }

            // 4. Notify admin
            $admin = User::where('user_type', 'admin')->first();
            if ($admin) {
                try {
                    \Notification::send($admin, new \App\Notifications\TelecallerBiodataCreated($user));
                } catch (\Exception $e) { }
            }

            flash(translate('Biodata profile created successfully.'))->success();
            return redirect()->route('telecalling.dashboard');
        });
    }

    public function admin_index()
    {
        $data['total_leads'] = ActiveLead::count();
        $data['total_inactive'] = InactiveLead::count();
        $data['total_telecallers'] = User::where('user_type', 'telecaller')->count();
        $data['total_calls_today'] = TelecallingCallLog::whereDate('call_time', date('Y-m-d'))->count();
        
        $recent_activities = TelecallingCallLog::latest()->limit(10)->get();

        return view('admin.telecalling.dashboard.admin_index', compact('data', 'recent_activities'));
    }
}
