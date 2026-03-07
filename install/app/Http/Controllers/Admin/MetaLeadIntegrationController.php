<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ActiveLead;

class MetaLeadIntegrationController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:telecalling_settings']);
    }

    public function index(Request $request)
    {
        $leads = ActiveLead::where('source', 'meta')->latest()->paginate(15);
        return view('admin.telecalling.meta_leads.index', compact('leads'));
    }
}
