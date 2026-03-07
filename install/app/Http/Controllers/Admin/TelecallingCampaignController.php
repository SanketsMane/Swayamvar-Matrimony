<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\TelecallingCampaign;

class TelecallingCampaignController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:telecalling_settings']);
    }

    public function index()
    {
        $campaigns = TelecallingCampaign::latest()->paginate(15);
        return view('admin.telecalling.campaigns.index', compact('campaigns'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|unique:telecalling_campaigns',
        ]);

        $campaign = new TelecallingCampaign;
        $campaign->name = $request->name;
        $campaign->description = $request->description;
        $campaign->status = 'active';
        
        if ($campaign->save()) {
            flash(translate('Campaign has been created successfully'))->success();
        } else {
            flash(translate('Something went wrong'))->error();
        }
        return back();
    }

    public function update(Request $request, $id)
    {
        $campaign = TelecallingCampaign::findOrFail($id);
        $campaign->name = $request->name;
        $campaign->description = $request->description;
        $campaign->status = $request->status;

        if ($campaign->save()) {
            flash(translate('Campaign has been updated successfully'))->success();
        } else {
            flash(translate('Something went wrong'))->error();
        }
        return back();
    }

    public function destroy($id)
    {
        if (TelecallingCampaign::destroy($id)) {
            flash(translate('Campaign has been deleted successfully'))->success();
        } else {
            flash(translate('Something went wrong'))->error();
        }
        return back();
    }
}
