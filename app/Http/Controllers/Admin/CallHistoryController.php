<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\TelecallingCallLog;
use Auth;

class CallHistoryController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:call_history']);
    }

    public function index(Request $request)
    {
        $logs = TelecallingCallLog::latest();

        // If not super admin, only show own logs [Sanket]
        if (Auth::user()->user_type == 'telecaller') {
            $logs = $logs->where('agent_id', Auth::id());
        }

        if ($request->has('lead_id')) {
            $logs = $logs->where('lead_id', $request->lead_id);
        }

        $logs = $logs->paginate(15);
        return view('admin.telecalling.call_history.index', compact('logs'));
    }

    public function lead_history($id)
    {
        $logs = TelecallingCallLog::where('lead_id', $id)->latest()->get();
        return view('admin.telecalling.call_history.history_partial', compact('logs'));
    }
}
