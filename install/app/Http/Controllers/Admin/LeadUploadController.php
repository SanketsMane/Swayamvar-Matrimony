<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\LeadUpload;
use App\Models\TelecallingCampaign;
use App\Imports\LeadsImport;
use Maatwebsite\Excel\Facades\Excel;
use Auth;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Reader\IReadFilter;
use DB;

class HeaderReadFilter implements IReadFilter
{
    public function readCell($columnAddress, $row, $worksheetName = '') {
        return $row == 1;
    }
}

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
            
            // Read ONLY the first row (headers) using PhpSpreadsheet directly to avoid memory exhaustion [Sanket]
            $headers = [];
            try {
                $reader = IOFactory::createReaderForFile($full_path);
                $reader->setReadDataOnly(true);
                $reader->setReadFilter(new HeaderReadFilter());
                
                $spreadsheet = $reader->load($full_path);
                $sheet = $spreadsheet->getActiveSheet();
                $headers = $sheet->toArray()[0] ?? [];
                
                $spreadsheet->disconnectWorksheets();
                unset($spreadsheet);
            } catch (\Exception $e) {
                \Log::error('Lead Upload Header Reading Error: ' . $e->getMessage());
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
            try {
                // Sanket: Efficiently read only the first row (headers)
                // Sanket: Use ReadFilter to only load headers, avoiding OOM for large files
                $reader = IOFactory::createReaderForFile($path);
                $reader->setReadDataOnly(true);
                $reader->setReadFilter(new HeaderReadFilter());
                
                $spreadsheet = $reader->load($path);
                $sheet = $spreadsheet->getActiveSheet();
                $headers = $sheet->toArray()[0] ?? [];
                
                // Cleanup memory
                $spreadsheet->disconnectWorksheets();
                unset($spreadsheet);
            } catch (\Exception $e) {
                flash(translate('Error reading file headers: ' . $e->getMessage()))->error();
                return redirect()->route('lead-upload.index');
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
        // Sanket: Allow infinite execution for large file imports
        set_time_limit(0);
        
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
        
        // Sanket: Calculate total rows for progress bar (memory-efficient)
        try {
            $reader = \PhpOffice\PhpSpreadsheet\IOFactory::createReaderForFile($path);
            $info = $reader->listWorksheetInfo($path);
            $totalRows = $info[0]['totalRows'] - 1; // Exclude header row
            $upload->update([
                'total_rows' => $totalRows,
                'processed_rows' => 0,
            ]);
        } catch (\Exception $e) {
            \Log::error('Lead Progress Init Error: ' . $e->getMessage());
        }

        // Sanket: Disable query log to save memory during bulk inserts
        DB::disableQueryLog();
        
        $import = new LeadsImport($upload->id, $upload->campaign_id, $mapping);
        Excel::import($import, $path);

        $stats = $import->getStats();
        
        // Final update for stats and status [Sanket]
        $upload->update([
            'total_leads' => $stats['total'],
            'valid_leads' => $stats['valid'],
            'duplicate_leads' => $stats['duplicate'],
            'invalid_leads' => $stats['invalid'],
            'status' => 'completed',
        ]);

        // Clean up temp file
        @unlink($path);

        flash(translate('Leads imported successfully.'))->success();
        
        return redirect()->route('lead-upload.index')->with('import_stats', $stats);
    }

    public function show($id)
    {
        $upload = LeadUpload::findOrFail($id);
        if ($upload->status == 'pending_mapping') {
            return redirect()->route('lead-upload.map', ['id' => $upload->id]);
        }
        return redirect()->route('lead-upload.index');
    }

    public function update(Request $request, $id)
    {
        // Placeholder to prevent 500 on accidental PUT requests
        flash(translate('Update not supported for this record type.'))->info();
        return back();
    }

    public function destroy($id)
    {
        if (LeadUpload::destroy($id)) {
            flash(translate('Upload record deleted'))->success();
        }
        return back();
    }
}
