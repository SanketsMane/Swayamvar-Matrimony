<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\BusinessSetting;

class TelecallingSettingsController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:telecalling_settings']);
    }

    public function index()
    {
        return view('admin.telecalling.settings.index');
    }

    public function store(Request $request)
    {
        foreach ($request->types as $key => $type) {
            $business_setting = BusinessSetting::where('type', $type)->first();
            if($business_setting != null){
                $business_setting->value = $request[$type];
                $business_setting->save();
            }
            else{
                $business_setting = new BusinessSetting;
                $business_setting->type = $type;
                $business_setting->value = $request[$type];
                $business_setting->save();
            }
        }

        flash(translate('Settings updated successfully'))->success();
        return back();
    }
}
