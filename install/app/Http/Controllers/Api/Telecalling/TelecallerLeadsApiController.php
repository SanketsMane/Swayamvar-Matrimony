<?php

namespace App\Http\Controllers\Api\Telecalling;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ActiveLead;
use Auth;

class TelecallerLeadsApiController extends Controller
{
    public function getAssignedLeads(Request $request)
    {
        $user_id = Auth::id();
        $query = ActiveLead::where('assigned_to', $user_id);

        // Optional Status Filter
        if ($request->has('status') && $request->status != '') {
            $query->where('status', $request->status);
        }

        // Optional Search Term
        if ($request->has('search') && $request->search != '') {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('mobile', 'like', "%{$search}%")
                  ->orWhere('city', 'like', "%{$search}%");
            });
        }

        // Ordering and Pagination
        $leads = $query->orderBy('created_at', 'desc')->paginate(15);

        return response()->json([
            'result' => true,
            'data' => $leads->items(),
            'current_page' => $leads->currentPage(),
            'last_page' => $leads->lastPage(),
            'total' => $leads->total(),
        ]);
    }

    public function updateStatus(Request $request, $id)
    {
        $user_id = Auth::id();
        $lead = ActiveLead::where('id', $id)->where('assigned_to', $user_id)->first();

        if (!$lead) {
            return response()->json(['result' => false, 'message' => 'Lead not found or access denied'], 404);
        }

        $request->validate([
            'status' => 'required',
            'notes' => 'nullable|string',
            'followup_date' => 'required_if:status,follow_up|nullable|date_format:Y-m-d'
        ]);

        return \DB::transaction(function () use ($lead, $request, $user_id) {
            $lead->status = $request->status;
            $lead->last_call_at = now();
            
            if ($request->has('notes') && !empty($request->notes)) {
                 $lead->notes = $request->notes . "\n[" . now()->format('Y-m-d H:i:s') . "] " . $lead->notes;
            }

            $lead->save();

            // Save Call Log
            \App\Models\TelecallingCallLog::create([
                'lead_id' => $lead->id,
                'lead_type' => 'active_lead',
                'agent_id' => $user_id,
                'status' => $request->status,
                'notes' => $request->notes,
                'call_time' => now()
            ]);

            // Handle Follow-ups
            if ($request->status == 'follow_up') {
                \App\Models\TelecallingFollowup::create([
                    'lead_id' => $lead->id,
                    'agent_id' => $user_id,
                    'followup_date' => $request->followup_date,
                    'notes' => $request->notes
                ]);
            }

            return response()->json([
                'result' => true,
                'message' => 'Lead status updated successfully',
                'lead' => $lead
            ]);
        });
    }

    public function getActiveCustomers(Request $request)
    {
        $user_id = Auth::id();
        $query = ActiveLead::where('assigned_to', $user_id)
                           ->where('status', 'active');

        if ($request->has('search') && $request->search != '') {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('mobile', 'like', "%{$search}%");
            });
        }

        $leads = $query->orderBy('created_at', 'desc')->paginate(15);

        return response()->json([
            'result' => true,
            'data' => $leads->items(),
            'current_page' => $leads->currentPage(),
            'last_page' => $leads->lastPage(),
            'total' => $leads->total(),
        ]);
    }

    public function getInactiveCustomers(Request $request)
    {
        $user_id = Auth::id();
        
        $query = ActiveLead::where('assigned_to', $user_id)
                           ->whereIn('status', ['rejected', 'not_interested', 'inactive']);

        if ($request->has('search') && $request->search != '') {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('mobile', 'like', "%{$search}%");
            });
        }

        $leads = $query->orderBy('updated_at', 'desc')->paginate(15);

        return response()->json([
            'result' => true,
            'data' => $leads->items(),
            'current_page' => $leads->currentPage(),
            'last_page' => $leads->lastPage(),
            'total' => $leads->total(),
        ]);
    }

    public function getCampaigns()
    {
        $campaigns = \App\Models\TelecallingCampaign::where('status', 'active')->get();
        return response()->json([
            'result' => true,
            'data' => $campaigns
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'mobile' => 'required|string|max:20',
            'email' => 'nullable|email|max:255',
            'city' => 'nullable|string|max:255',
            'pincode' => 'nullable|string|max:10',
            'campaign_id' => 'required|exists:telecalling_campaigns,id',
            'source' => 'nullable|string|max:255',
            'business_type' => 'nullable|string|max:255',
        ]);

        // Sanket: Check for duplicate lead before creating
        $existing = ActiveLead::where('mobile', $request->mobile)
                            ->orWhere(function($q) use ($request) {
                                if ($request->email) {
                                    $q->where('email', $request->email);
                                }
                            })->first();

        if ($existing) {
            return response()->json([
                'result' => false,
                'message' => 'A lead with this mobile or email already exists.'
            ], 422);
        }

        $user_id = Auth::id();

        $lead = new ActiveLead();
        $lead->name = $request->name;
        $lead->mobile = $request->mobile;
        $lead->email = $request->email;
        $lead->city = $request->city;
        $lead->pincode = $request->pincode;
        $lead->campaign_id = $request->campaign_id;
        $lead->source = $request->source ?? 'Mobile App';
        $lead->business_type = $request->business_type;
        $lead->assigned_to = $user_id;
        $lead->status = 'New';
        $lead->save();

        return response()->json([
            'result' => true,
            'message' => 'Lead added successfully',
            'data' => $lead
        ]);
    }
}
