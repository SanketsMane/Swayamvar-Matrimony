<?php

namespace App\Http\Controllers\Api\Telecalling;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\TelecallerCouponUsage;
use App\Models\TelecallerDetail;
use Auth;

class TelecallerCommissionApiController extends Controller
{
    public function getCommissionStats(Request $request)
    {
        $user_id = Auth::id();
        
        $telecaller_details = TelecallerDetail::where('user_id', $user_id)->first();
        $total_commission = TelecallerCouponUsage::where('telecaller_id', $user_id)->sum('commission_amount');
        
        $usages = TelecallerCouponUsage::where('telecaller_id', $user_id)
            ->latest()
            ->paginate(15);

        return response()->json([
            'result' => true,
            'coupon_code' => $telecaller_details->coupon_code ?? 'N/A',
            'commission_percent' => $telecaller_details->commission_percent ?? 0,
            'total_commission' => (float)$total_commission,
            'commission_history' => $usages->items(),
            'current_page' => $usages->currentPage(),
            'last_page' => $usages->lastPage()
        ]);
    }
}
// Sanket
