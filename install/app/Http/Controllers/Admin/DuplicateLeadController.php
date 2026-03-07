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
        $leads = DuplicateLead::latest()->paginate(15);
        return view('admin.telecalling.duplicate_leads.index', compact('leads'));
    }

    public function destroy($id)
    {
        DuplicateLead::destroy($id);
        flash(translate('Duplicate lead record removed'))->success();
        return back();
    }
}
