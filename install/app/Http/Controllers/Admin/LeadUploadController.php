<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\LeadUpload;
use App\Models\TelecallingCampaign;
use App\Imports\LeadsImport;
use Excel;
use Auth;

class LeadUploadController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:lead_upload']);
    }

    public function index()
    {
        $uploads = LeadUpload::latest()->paginate(15);
        $campaigns = TelecallingCampaign::where('status', 'active')->get();
        return view('admin.telecalling.lead_uploads.index', compact('uploads', 'campaigns'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'campaign_id' => 'required',
            'lead_file' => 'required|mimes:xlsx,csv,xls',
        ]);

        if ($request->hasFile('lead_file')) {
            $file = $request->file('lead_file');
            $file_name = time() . '_' . $file->getClientOriginalName();
            
            // Move file temporarily to storage for mapping phase [Sanket]
            $file->move(storage_path('app/temp_lead_uploads'), $file_name);
            $full_path = storage_path('app/temp_lead_uploads/' . $file_name);
            
            // Read ONLY the first row (headers) to show in the mapping UI [Sanket]
            $headers = [];
            try {
                $data = Excel::toArray(new \stdClass(), $full_path);
                if (isset($data[0]) && count($data[0]) > 0) {
                    $headers = $data[0][0]; // First sheet, first row
                }
            } catch (\Exception $e) {
                \Log::error('Lead Upload Error: ' . $e->getMessage());
                flash(translate('Failed to read Excel file headers.'))->error();
                return back();
            }

            // Temporarily store upload reference without finalizing [Sanket]
            $upload = LeadUpload::create([
                'file_name' => $file_name,
                'campaign_id' => $request->campaign_id,
                'user_id' => Auth::id(),
                'status' => 'pending_mapping', // Requires migration or just handle state conceptually
            ]);

            // Redirect to mapping screen
            return redirect()->route('lead-upload.map', ['id' => $upload->id]);
        }

        flash(translate('Please select a valid file'))->error();
        return back();
    }

    // Sanket: New Mapping View
    public function map($id)
    {
        $upload = LeadUpload::findOrFail($id);
        $campaign = TelecallingCampaign::find($upload->campaign_id);

        // Re-read headers
        $headers = [];
        $path = storage_path('app/temp_lead_uploads/' . $upload->file_name);
        
        if (file_exists($path)) {
            $data = Excel::toArray(new \stdClass(), $path);
            if (isset($data[0]) && count($data[0]) > 0) {
                // Ensure headers are non-empty strings for dropdown labels
                foreach($data[0][0] as $index => $col) {
                    $headers[$index] = $col ?: "Column " . ($index + 1);
                }
            }
        } else {
            flash(translate('Upload file missing.'))->error();
            return redirect()->route('lead-upload.index');
        }

        $dbFields = [
            'name' => 'Name',
            'mobile' => 'Mobile Number (mandatory)',
            'email' => 'Email',
            'city' => 'City',
            'pincode' => 'Pincode',
            'source' => 'Source',
            'business_type' => 'Business Type',
        ];

        return view('admin.telecalling.lead_uploads.map', compact('upload', 'campaign', 'headers', 'dbFields'));
    }

    // Sanket: Final Processing
    public function processImport(Request $request, $id)
    {
        $upload = LeadUpload::findOrFail($id);
        
        $request->validate([
            'mapping.mobile' => 'required|numeric' // Ensure mobile is mapped
        ]);

        $path = storage_path('app/temp_lead_uploads/' . $upload->file_name);
        if (!file_exists($path)) {
            flash(translate('Upload file missing.'))->error();
            return redirect()->route('lead-upload.index');
        }

        // Pass the mapping to the Import class
        $mapping = $request->mapping; // ['name' => 0, 'mobile' => 2, ...]
        
        $import = new LeadsImport($upload->id, $upload->campaign_id, $mapping);
        Excel::import($import, $path);

        $stats = $import->getStats();
        
        // Clean up temp file
        @unlink($path);

        flash(translate('Leads imported successfully.'))->success();
        
        return redirect()->route('lead-upload.index')->with('import_stats', $stats);
    }

    public function destroy($id)
    {
        if (LeadUpload::destroy($id)) {
            flash(translate('Upload record deleted'))->success();
        }
        return back();
    }
}
