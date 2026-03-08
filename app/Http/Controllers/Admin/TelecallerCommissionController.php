<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\TelecallerCouponUsage;
use App\Models\User;
use Auth;

class TelecallerCommissionController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:telecalling_reports'])->only('index');
    }

    public function index(Request $request)
    {
        $sort_agent = null;
        $usages = TelecallerCouponUsage::latest();

        if ($request->has('agent_id') && $request->agent_id != null) {
            $usages = $usages->where('telecaller_id', $request->agent_id);
            $sort_agent = $request->agent_id;
        }

        $usages = $usages->paginate(15);
        $agents = User::where('user_type', 'telecaller')->get();

        return view('admin.telecalling.commissions.index', compact('usages', 'agents', 'sort_agent'));
    }

    public function my_commissions(Request $request)
    {
        $user_id = Auth::id();
        $usages = TelecallerCouponUsage::where('telecaller_id', $user_id)->latest()->paginate(15);
        
        $telecaller_details = \App\Models\TelecallerDetail::where('user_id', $user_id)->first();
        $total_commission = TelecallerCouponUsage::where('telecaller_id', $user_id)->sum('commission_amount');

        return view('admin.telecalling.commissions.my_commissions', compact('usages', 'telecaller_details', 'total_commission'));
    }
}
