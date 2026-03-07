<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\InactiveLead;
use App\Models\ActiveLead;

class InactiveLeadController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:inactive_leads_view']);
    }

    public function index(Request $request)
    {
        $sort_search = null;
        $leads = InactiveLead::latest();

        if ($request->has('search')){
            $sort_search = $request->search;
            $leads = $leads->where(function ($query) use ($sort_search) {
                $query->where('name', 'like', '%'.$sort_search.'%')
                      ->orWhere('email', 'like', '%'.$sort_search.'%')
                      ->orWhere('mobile', 'like', '%'.$sort_search.'%');
            });
        }

        $leads = $leads->paginate(15);
        return view('admin.telecalling.inactive_leads.index', compact('leads', 'sort_search'));
    }

    public function restore($id)
    {
        $lead = InactiveLead::findOrFail($id);
        
        ActiveLead::create([
            'name' => $lead->name,
            'mobile' => $lead->mobile,
            'email' => $lead->email,
            'city' => $lead->city,
            'pincode' => $lead->pincode,
            'source' => $lead->source,
            'business_type' => $lead->business_type,
            'campaign_id' => $lead->campaign_id,
            'upload_id' => $lead->upload_id,
            'status' => 'Restored',
        ]);

        $lead->delete(); // Soft delete [Sanket]

        flash(translate('Lead restored to active list'))->success();
        return back();
    }
}
