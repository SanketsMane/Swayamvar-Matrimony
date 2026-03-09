<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\LeadUpload;

class LeadImportProgressController extends Controller
{
    public function getProgress($id)
    {
        $upload = LeadUpload::find($id);
        if (!$upload) {
            return response()->json(['error' => 'Upload not found'], 404);
        }

        $percentage = 0;
        if ($upload->total_rows > 0) {
            $percentage = min(100, round(($upload->processed_rows / $upload->total_rows) * 100));
        }

        return response()->json([
            'percentage' => $percentage,
            'processed' => $upload->processed_rows,
            'total' => $upload->total_rows,
            'status' => $upload->status,
            'valid' => $upload->valid_leads,
            'duplicate' => $upload->duplicate_leads,
            'invalid' => $upload->invalid_leads,
        ]);
    }
}
