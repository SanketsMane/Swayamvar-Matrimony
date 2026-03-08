<?php

namespace App\Http\Controllers\Api\Telecalling;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\TelecallingCallLog;
use Auth;

class TelecallerCallHistoryApiController extends Controller
{
    public function getCallHistory(Request $request)
    {
        $user_id = Auth::id();
        
        $query = TelecallingCallLog::with('lead')
                        ->where('agent_id', $user_id);

        if ($request->has('search') && !empty($request->search)) {
            $search = $request->search;
            $query->whereHasMorph('lead', ['App\Models\ActiveLead', 'App\Models\InactiveLead'], function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('mobile', 'like', "%{$search}%");
            });
        }

        $logs = $query->orderBy('call_time', 'desc')->paginate(15);

        return response()->json([
            'result' => true,
            'data' => $logs->items(),
            'current_page' => $logs->currentPage(),
            'last_page' => $logs->lastPage(),
            'total' => $logs->total()
        ]);
    }

    public function getLeadCallHistory($leadId)
    {
        $user_id = Auth::id();
        
        $logs = TelecallingCallLog::where('lead_id', $leadId)
                        ->where('agent_id', $user_id)
                        ->orderBy('call_time', 'desc')
                        ->get();

        return response()->json([
            'result' => true,
            'data' => $logs
        ]);
    }
}
