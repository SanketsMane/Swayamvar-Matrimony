<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\TelecallerDetail;
use App\Models\Role;
use Hash;
use Str;
use App\Utility\EmailUtility;
use App\Utility\SmsUtility;

class TelecallerController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:manage_telecallers']);
    }

    public function index(Request $request)
    {
        $sort_search = null;
        $telecallers = User::where('user_type', 'telecaller')->latest();
        
        if ($request->has('search')){
            $sort_search = $request->search;
            $telecallers = $telecallers->where(function ($query) use ($sort_search) {
                $query->where('first_name', 'like', '%'.$sort_search.'%')
                      ->orWhere('last_name', 'like', '%'.$sort_search.'%')
                      ->orWhere('email', 'like', '%'.$sort_search.'%')
                      ->orWhere('phone', 'like', '%'.$sort_search.'%');
            });
        }
        
        $telecallers = $telecallers->paginate(15);
        return view('admin.telecalling.telecallers.index', compact('telecallers', 'sort_search'));
    }

    public function create()
    {
        return view('admin.telecalling.telecallers.create');
    }

    public function store(Request $request)
    {
        $request->validate([
            'first_name' => 'required',
            'last_name' => 'required',
            'email' => 'required|email|unique:users',
            'phone' => 'required|unique:users',
        ]);

        $password = Str::random(10);
        
        $user = new User;
        $user->first_name = $request->first_name;
        $user->last_name = $request->last_name;
        $user->email = $request->email;
        $user->phone = $request->phone;
        $user->user_type = 'telecaller';
        $user->password = Hash::make($password);
        
        if ($user->save()) {
            $telecaller_detail = new TelecallerDetail;
            $telecaller_detail->user_id = $user->id;
            $telecaller_detail->pincode = $request->pincode;
            $telecaller_detail->department = $request->department;
            $telecaller_detail->city = $request->city;
            $telecaller_detail->state = $request->state;
            $telecaller_detail->coupon_code = $request->coupon_code;
            $telecaller_detail->discount_percent = $request->discount_percent;
            $telecaller_detail->commission_percent = $request->commission_percent;
            $telecaller_detail->save();

            $user->assignRole('Telecalling Agent');

            // Send Email Automation [Sanket]
            try {
                \Mail::to($user->email)->send(new \App\Mail\TelecallerAccountCreated($user, $password));
            } catch (\Exception $e) {
                // Log error but continue
                \Log::error("Failed to send telecaller creation mail: " . $e->getMessage());
            }

            flash(translate('Telecaller has been created successfully. Password: ') . $password)->success();
            return redirect()->route('telecallers.index');
        }

        flash(translate('Something went wrong'))->error();
        return back();
    }

    public function edit($id)
    {
        $telecaller = User::findOrFail(decrypt($id));
        return view('admin.telecalling.telecallers.edit', compact('telecaller'));
    }

    public function update(Request $request, $id)
    {
        $user = User::findOrFail($id);
        
        $request->validate([
            'first_name' => 'required',
            'last_name' => 'required',
            'email' => 'required|email|unique:users,email,'.$user->id,
            'phone' => 'required|unique:users,phone,'.$user->id,
        ]);

        $user->first_name = $request->first_name;
        $user->last_name = $request->last_name;
        $user->email = $request->email;
        $user->phone = $request->phone;
        
        if ($user->save()) {
            $telecaller_detail = TelecallerDetail::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'pincode' => $request->pincode,
                    'department' => $request->department,
                    'city' => $request->city,
                    'state' => $request->state,
                    'coupon_code' => $request->coupon_code,
                    'discount_percent' => $request->discount_percent,
                    'commission_percent' => $request->commission_percent,
                ]
            );

            flash(translate('Telecaller has been updated successfully'))->success();
            return redirect()->route('telecallers.index');
        }

        flash(translate('Something went wrong'))->error();
        return back();
    }

    public function destroy($id)
    {
        $user = User::findOrFail($id);
        if (User::destroy($id)) {
            // TelecallerDetail will be deleted via cascade if set up, or manually:
            TelecallerDetail::where('user_id', $id)->delete();
            flash(translate('Telecaller has been deleted successfully'))->success();
            return redirect()->route('telecallers.index');
        }

        flash(translate('Something went wrong'))->error();
        return back();
    }

    public function update_status(Request $request)
    {
        $user = User::findOrFail($request->id);
        $user->approved = $request->status;
        if ($user->save()) {
            return 1;
        }
        return 0;
    }

    public function reset_password(Request $request)
    {
        $user = User::findOrFail($request->id);
        $password = Str::random(10);
        
        $user->password = Hash::make($password);
        if ($user->save()) {
            // Send new password via email [Sanket]
            try {
                \Mail::to($user->email)->send(new \App\Mail\TelecallerAccountCreated($user, $password));
            } catch (\Exception $e) {
                \Log::error("Failed to send telecaller password reset mail: " . $e->getMessage());
            }

            flash(translate('Password reset successfully. New Password: ') . $password)->success();
            return back();
        }

        flash(translate('Something went wrong'))->error();
        return back();
    }

    public function performance($id)
    {
        $telecaller = User::findOrFail(decrypt($id));
        
        // Get biodatas created by this telecaller
        $biodatas = User::where('user_type', 'member')
                        ->where('telecaller_id', $telecaller->id)
                        ->latest()
                        ->paginate(10, ['*'], 'biodatas_page');

        // Get package payments sold by this telecaller
        $payments = \App\Models\PackagePayment::where('telecaller_id', $telecaller->id)
                                              ->latest()
                                              ->paginate(10, ['*'], 'payments_page');

        return view('admin.telecalling.telecallers.performance', compact('telecaller', 'biodatas', 'payments'));
    }

    // Sanket: Admin view — all biodatas filled by any telecaller across the system
    public function biodataTracking(Request $request)
    {
        $search = $request->search;
        $telecaller_filter = $request->telecaller_id;

        $query = User::where('user_type', 'member')
                     ->whereNotNull('telecaller_id')
                     ->with(['telecaller', 'member.package', 'spiritual_backgrounds.religion', 'spiritual_backgrounds.caste']);

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('first_name', 'like', "%{$search}%")
                  ->orWhere('last_name', 'like', "%{$search}%")
                  ->orWhere('phone', 'like', "%{$search}%")
                  ->orWhere('code', 'like', "%{$search}%");
            });
        }

        if ($telecaller_filter) {
            $query->where('telecaller_id', $telecaller_filter);
        }

        $biodatas = $query->latest()->paginate(20);
        $telecallers = User::where('user_type', 'telecaller')->select('id', 'first_name', 'last_name')->get();

        return view('admin.telecalling.telecallers.biodata_tracking', compact('biodatas', 'telecallers', 'search', 'telecaller_filter'));
    }
}
