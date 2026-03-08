<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ActiveLead;
use App\Models\InactiveLead;
use App\Models\User;

class ActiveLeadController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:active_leads_view']);
    }

    public function index(Request $request)
    {
        $sort_search = null;
        $leads = ActiveLead::latest();

        if ($request->has('search')){
            $sort_search = $request->search;
            $leads = $leads->where(function ($query) use ($sort_search) {
                $query->where('name', 'like', '%'.$sort_search.'%')
                      ->orWhere('email', 'like', '%'.$sort_search.'%')
                      ->orWhere('mobile', 'like', '%'.$sort_search.'%');
            });
        }

        $leads = $leads->paginate(15);
        $telecallers = User::where('user_type', 'telecaller')->where('approved', 1)->get();

        return view('admin.telecalling.active_leads.index', compact('leads', 'sort_search', 'telecallers'));
    }

    public function create()
    {
        $campaigns = \App\Models\TelecallingCampaign::where('status', 'active')->get();
        $telecallers = User::where('user_type', 'telecaller')->where('approved', 1)->get();
        return view('admin.telecalling.active_leads.create', compact('campaigns', 'telecallers'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|max:255',
            'mobile' => 'required|max:20',
            'email' => 'nullable|email|max:255',
            'campaign_id' => 'required',
        ]);

        ActiveLead::create([
            'name' => $request->name,
            'mobile' => $request->mobile,
            'email' => $request->email,
            'city' => $request->city,
            'pincode' => $request->pincode,
            'source' => $request->source ?? 'Offline / Manual',
            'business_type' => $request->business_type,
            'campaign_id' => $request->campaign_id,
            'assigned_to' => $request->assigned_to,
            'status' => $request->assigned_to ? 'Assigned' : 'Unassigned',
        ]);

        flash(translate('Offline lead added successfully'))->success();
        return redirect()->route('active-leads.index');
    }

    public function mark_inactive(Request $request, $id)
    {
        $lead = ActiveLead::findOrFail($id);
        
        InactiveLead::create([
            'name' => $lead->name,
            'mobile' => $lead->mobile,
            'email' => $lead->email,
            'city' => $lead->city,
            'pincode' => $lead->pincode,
            'source' => $lead->source,
            'business_type' => $lead->business_type,
            'campaign_id' => $lead->campaign_id,
            'upload_id' => $lead->upload_id,
            'marked_by' => \Auth::id(),
            'previous_agent_id' => $lead->assigned_to,
            'reason' => $request->reason,
            'notes' => $request->notes,
        ]);

        $lead->delete(); // Soft delete [Sanket]

        flash(translate('Lead marked as inactive'))->dark();
        return back();
    }
}
