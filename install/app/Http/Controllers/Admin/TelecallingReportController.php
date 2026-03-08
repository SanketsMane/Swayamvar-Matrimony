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
            $data['total_biodatas'] = User::where('user_type', 'member')->whereNotNull('telecaller_id')->count();
            
            $data['leads_by_status'] = ActiveLead::select('status', DB::raw('count(*) as total'))
                ->groupBy('status')
                ->get();
                
            $data['agent_performance'] = User::where('user_type', 'telecaller')
                ->withCount([
                    'assigned_leads', 
                    'call_logs',
                    'biodatas'
                ])
                ->get();

            // Daily, Weekly, Monthly Stats [Sanket]
            $data['biodatas_today'] = User::where('user_type', 'member')->whereNotNull('telecaller_id')->whereDate('created_at', date('Y-m-d'))->count();
            $data['biodatas_this_week'] = User::where('user_type', 'member')->whereNotNull('telecaller_id')->whereBetween('created_at', [now()->startOfWeek(), now()->endOfWeek()])->count();
            $data['biodatas_this_month'] = User::where('user_type', 'member')->whereNotNull('telecaller_id')->whereMonth('created_at', date('m'))->whereYear('created_at', date('Y'))->count();

            return view('admin.telecalling.reports.index', compact('data'));
        } catch (\Exception $e) {
            \Log::error('Reports Page Error: ' . $e->getMessage());
            flash(translate('Something went wrong') . ': ' . $e->getMessage())->error();
            return redirect()->route('admin.dashboard');
        }
    }
}
