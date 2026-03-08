<?php

namespace App\Http\Controllers\Api\Telecalling;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\TelecallingFollowup;
use Auth;

class TelecallerFollowupApiController extends Controller
{
    public function getFollowups(Request $request)
    {
        $user_id = Auth::id();
        $today = date('Y-m-d');
        
        $type = $request->get('type', 'today'); // 'today', 'upcoming', 'overdue'

        $query = TelecallingFollowup::with('lead')
                         ->where('agent_id', $user_id);

        if ($type == 'today') {
            $query->whereDate('followup_date', $today);
        } elseif ($type == 'upcoming') {
            $query->whereDate('followup_date', '>', $today);
        } elseif ($type == 'overdue') {
            $query->whereDate('followup_date', '<', $today);
        }

        $followups = $query->orderBy('followup_date', 'asc')->paginate(15);

        return response()->json([
            'result' => true,
            'data' => $followups->items(),
            'current_page' => $followups->currentPage(),
            'last_page' => $followups->lastPage(),
            'total' => $followups->total(),
        ]);
    }
}
