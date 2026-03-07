<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ActiveLead;
use App\Models\User;
use App\Models\TelecallingCampaign;
use App\Models\LeadUpload;
use App\Services\FirebasePushService;

class LeadDistributionController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:lead_distribution']);
    }

    public function index()
    {
        $campaigns = TelecallingCampaign::where('status', 'active')->get();
        $telecallers = User::where('user_type', 'telecaller')->where('approved', 1)->get();
        $unassigned_count = ActiveLead::where('assigned_to', null)->count();
        
        return view('admin.telecalling.lead_distribution.index', compact('campaigns', 'telecallers', 'unassigned_count'));
    }

    public function distribute_equal(Request $request)
    {
        $request->validate([
            'telecaller_ids' => 'required|array',
            'campaign_id' => 'required',
        ]);

        $leads = ActiveLead::where('campaign_id', $request->campaign_id)
            ->where('assigned_to', null)
            ->get();

        if ($leads->isEmpty()) {
            flash(translate('No unassigned leads found for this campaign'))->warning();
            return back();
        }

        $telecaller_ids = $request->telecaller_ids;
        $telecaller_count = count($telecaller_ids);
        
        foreach ($leads as $key => $lead) {
            $telecaller_id = $telecaller_ids[$key % $telecaller_count];
            $lead->update([
                'assigned_to' => $telecaller_id,
                'status' => 'Assigned'
            ]);
        }

        // Notify telecallers
        foreach ($telecaller_ids as $tid) {
            $tele_user = User::find($tid);
            if ($tele_user) {
                FirebasePushService::sendToUser($tele_user, translate('New Leads Assigned'), translate('You have been assigned new leads. Check your dashboard.'));
            }
        }

        flash(translate('Leads distributed equally successfully'))->success();
        return back();
    }

    public function distribute_pincode(Request $request)
    {
        $request->validate([
            'campaign_id' => 'required',
        ]);

        $leads = ActiveLead::where('campaign_id', $request->campaign_id)
            ->where('assigned_to', null)
            ->whereNotNull('pincode')
            ->get();

        $assigned_count = 0;
        foreach ($leads as $lead) {
            // Find telecallers with matching pincode [Sanket]
            $telecaller = User::where('user_type', 'telecaller')
                ->whereHas('telecaller_detail', function($q) use ($lead) {
                    $q->where('pincode', 'like', '%'.$lead->pincode.'%');
                })->first();

            if ($telecaller) {
                $lead->update([
                    'assigned_to' => $telecaller->id,
                    'status' => 'Assigned'
                ]);
                $assigned_count++;
                
                // Notify telecaller for each match (Optimized: in production, you might group these)
                FirebasePushService::sendToUser($telecaller, translate('New Lead Assigned'), translate('A new lead matching your PIN code has been assigned.'));
            }
        }

        flash(translate($assigned_count . ' leads assigned based on PIN code'))->success();
        return back();
    }

    public function manual_assignment(Request $request)
    {
        $request->validate([
            'lead_ids' => 'required|array',
            'telecaller_id' => 'required',
        ]);

        ActiveLead::whereIn('id', $request->lead_ids)->update([
            'assigned_to' => $request->telecaller_id,
            'status' => 'Assigned'
        ]);

        $tele_user = User::find($request->telecaller_id);
        if ($tele_user) {
            FirebasePushService::sendToUser($tele_user, translate('New Leads Assigned'), translate('Admin manually assigned you ' . count($request->lead_ids) . ' leads.'));
        }

        flash(translate('Selected leads assigned successfully'))->success();
        return back();
    }

    public function get_unassigned_leads(Request $request)
    {
        $leads = ActiveLead::where('campaign_id', $request->campaign_id)
            ->where('assigned_to', null)
            ->latest()
            ->get();
            
        return view('admin.telecalling.lead_distribution.lead_list_partial', compact('leads'));
    }
}
