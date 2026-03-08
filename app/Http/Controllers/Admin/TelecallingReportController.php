<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\TelecallingCallLog;
use App\Models\ActiveLead;
use App\Models\User;
use DB;

class TelecallingReportController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:telecalling_reports']);
    }

    public function index()
    {
        try {
            // General stats for reports [Sanket]
            $data['total_calls'] = TelecallingCallLog::count();
            $data['leads_by_status'] = ActiveLead::select('status', DB::raw('count(*) as total'))
                ->groupBy('status')
                ->get();
                
            $data['agent_performance'] = User::where('user_type', 'telecaller')
                ->withCount(['assigned_leads', 'call_logs'])
                ->get();

            return view('admin.telecalling.reports.index', compact('data'));
        } catch (\Exception $e) {
            \Log::error('Reports Page Error: ' . $e->getMessage());
            flash(translate('Something went wrong') . ': ' . $e->getMessage())->error();
            return redirect()->route('admin.dashboard');
        }
    }
}
