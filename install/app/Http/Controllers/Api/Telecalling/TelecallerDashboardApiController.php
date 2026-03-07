<?php

namespace App\Http\Controllers\Api\Telecalling;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\TelecallingFollowup;
use Auth;

class TelecallerDashboardApiController extends Controller
{
    public function getDashboardStats(Request $request)
    {
        try {
            $user_id = Auth::id();
            $today = date('Y-m-d');

            // Optimized KPI calculation (Single Pass on ActiveLeads)
            $stats = \App\Models\ActiveLead::where('assigned_to', $user_id)
                ->selectRaw("
                    COUNT(*) as total_active_assigned,
                    COUNT(CASE WHEN DATE(created_at) = '$today' THEN 1 END) as todays_leads,
                    COUNT(CASE WHEN last_call_at IS NULL THEN 1 END) as pending_calls,
                    COUNT(CASE WHEN status = 'active' THEN 1 END) as active_customers,
                    COUNT(CASE WHEN status = 'converted' THEN 1 END) as converted_count
                ")
                ->first();

            $inactive_customers = \App\Models\InactiveLead::where('marked_inactive_by', $user_id)->count();
            
            $follow_ups_count = \App\Models\TelecallingFollowup::where('agent_id', $user_id)
                ->whereDate('followup_date', $today)
                ->count();

            $total_assigned = (int)$stats->total_active_assigned + $inactive_customers;
            $conversion_rate = $total_assigned > 0 ? round(($stats->converted_count / $total_assigned) * 100, 2) : 0;

            // Fetch Real Priority Lead (Latest assigned, pending call)
            $priority_lead = \App\Models\ActiveLead::where('assigned_to', $user_id)
                ->whereNull('last_call_at')
                ->orderBy('id', 'desc')
                ->first();

            // Fetch Today's Timeline (Real Followups)
            $timeline = \App\Models\TelecallingFollowup::where('agent_id', $user_id)
                ->whereDate('followup_date', $today)
                ->with('lead')
                ->orderBy('followup_date', 'asc')
                ->take(5)
                ->get();

            // Fetch Chart Data (Last 7 days call count)
            $chart_data = [];
            for ($i = 6; $i >= 0; $i--) {
                $date = date('Y-m-d', strtotime("-$i days"));
                $count = \App\Models\TelecallingCallLog::where('agent_id', $user_id)
                    ->whereDate('call_time', $date)
                    ->count();
                $chart_data[] = ['date' => date('D', strtotime($date)), 'count' => $count];
            }

            $telecaller_details = \App\Models\TelecallerDetail::where('user_id', $user_id)->first();

            return response()->json([
                'result' => true,
                'kpis' => [
                    'todays_leads' => (int)$stats->todays_leads,
                    'pending_calls' => (int)$stats->pending_calls,
                    'follow_ups' => (int)$follow_ups_count,
                    'active_customers' => (int)$stats->active_customers,
                    'inactive_customers' => (int)$inactive_customers,
                    'conversion_rate' => (float)$conversion_rate,
                    'total_assigned' => (int)$total_assigned,
                    'coupon_code' => $telecaller_details->coupon_code ?? 'N/A',
                ],
                'priority_lead' => $priority_lead,
                'upcoming_followups' => $timeline,
                'performance_chart' => $chart_data
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'result' => false,
                'message' => 'Error fetching dashboard stats: ' . $e->getMessage()
            ], 500);
        }
    }
}
// Sanket
