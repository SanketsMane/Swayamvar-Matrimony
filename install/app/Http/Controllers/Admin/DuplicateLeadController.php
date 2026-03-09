<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\DuplicateLead;

class DuplicateLeadController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:duplicate_leads']);
    }

    public function index(Request $request)
    {
        $leads = DuplicateLead::with('upload.campaign')->latest()->paginate(15);
        return view('admin.telecalling.duplicate_leads.index', compact('leads'));
    }

    public function show($id)
    {
        $lead = DuplicateLead::findOrFail($id);
        return response()->json([
            'data' => $lead->data,
            'mobile' => $lead->mobile,
            'name' => $lead->name,
            'mapping' => $lead->upload->column_mapping
        ]);
    }

    public function resolve(Request $request, $id)
    {
        $duplicate = DuplicateLead::findOrFail($id);
        $action = $request->action; // 'force_import' or 'merge'

        if ($action == 'force_import') {
            $existingActive = \App\Models\ActiveLead::where('mobile', $duplicate->mobile)->first();
            
            // If it already exists in active leads, we can either skip or update
            $lead = new \App\Models\ActiveLead();
            $lead->mobile = $duplicate->mobile;
            $lead->name = $duplicate->getMappingValue('name') ?? $duplicate->name;
            $lead->email = $duplicate->getMappingValue('email');
            $lead->city = $duplicate->getMappingValue('city');
            $lead->pincode = $duplicate->getMappingValue('pincode');
            $lead->source = $duplicate->getMappingValue('source');
            $lead->business_type = $duplicate->getMappingValue('business_type');
            $lead->campaign_id = $duplicate->upload->campaign_id;
            $lead->upload_id = $duplicate->upload_id;
            $lead->status = 'New';
            $lead->save();

            // Update stats
            $duplicate->upload->increment('valid_leads');
            $duplicate->upload->decrement('duplicate_leads');
            
            $duplicate->delete();
            flash(translate('Duplicate lead forced as new lead successfully.'))->success();
        }

        return back();
    }

    public function destroy($id)
    {
        $duplicate = DuplicateLead::findOrFail($id);
        $duplicate->upload->decrement('duplicate_leads');
        $duplicate->delete();
        flash(translate('Duplicate lead record removed'))->success();
        return back();
    }
}
