<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ActiveLead;
use App\Models\User;
use App\Services\FirebasePushService;

class ReassignmentController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:reassignment']);
    }

    public function index()
    {
        $telecallers = User::where('user_type', 'telecaller')->where('approved', 1)->get();
        return view('admin.telecalling.reassignment.index', compact('telecallers'));
    }

    public function get_telecaller_leads(Request $request)
    {
        $leads = ActiveLead::where('assigned_to', $request->telecaller_id)->get();
        return view('admin.telecalling.reassignment.lead_list_partial', compact('leads'));
    }

    public function reassign(Request $request)
    {
        $request->validate([
            'lead_ids' => 'required|array',
            'new_agent_id' => 'required',
        ]);

        ActiveLead::whereIn('id', $request->lead_ids)->update([
            'assigned_to' => $request->new_agent_id,
        ]);

        $tele_user = User::find($request->new_agent_id);
        if ($tele_user) {
            FirebasePushService::sendToUser($tele_user, translate('Leads Reassigned'), translate('Admin reassigned ' . count($request->lead_ids) . ' leads to you.'));
        }

        flash(translate('Leads reassigned successfully'))->success();
        return back();
    }
}
