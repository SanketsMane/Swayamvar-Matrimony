<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\LeadUpload;
use App\Imports\LeadsImport;
use Maatwebsite\Excel\Facades\Excel;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ManualLeadSeeding extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'lead:seed-manual {file} {campaign_id}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Manually seed leads from a specific Excel file and campaign ID';

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $filePath = $this->argument('file');
        $campaignId = $this->argument('campaign_id');
        $fullPath = storage_path('app/temp_lead_uploads/' . $filePath);

        if (!file_exists($fullPath)) {
            $this->error("File not found: $fullPath");
            return 1;
        }

        $this->info("Starting manual seeding for file: $filePath, Campaign: $campaignId");

        // 1. Create a LeadUpload record to track progress [Sanket]
        $upload = LeadUpload::create([
            'file_name' => $filePath,
            'campaign_id' => $campaignId,
            'user_id' => 2, // Assuming Admin ID is 2 from previous logs
            'status' => 'processing',
        ]);

        // 2. Initialize progress tracking [Sanket]
        try {
            $reader = \PhpOffice\PhpSpreadsheet\IOFactory::createReaderForFile($fullPath);
            $info = $reader->listWorksheetInfo($fullPath);
            $totalRows = $info[0]['totalRows'] - 1; // Exclude header row
            $upload->update([
                'total_rows' => $totalRows,
                'processed_rows' => 0,
            ]);
            $this->info("Total rows to process: $totalRows");
        } catch (\Exception $e) {
            $this->warn("Progress Init Warning: " . $e->getMessage());
        }

        // 3. Define the mapping manually for this specific file [Sanket]
        // Headers: ["Name","Mobile Number","Permanent Address","PINCODE"]
        $mapping = [
            'name' => 0,
            'mobile' => 1,
            'city' => 2,
            'pincode' => 3
        ];

        // 4. Run Import [Sanket]
        DB::disableQueryLog();
        $import = new LeadsImport($upload->id, $campaignId, $mapping);
        
        $this->info("Importing leads... Please wait.");
        
        try {
            Excel::import($import, $fullPath);
        } catch (\Exception $e) {
            $this->error("Import Error: " . $e->getMessage());
            Log::error("Manual Import Error: " . $e->getMessage());
            $upload->update(['status' => 'failed']);
            return 1;
        }

        $stats = $import->getStats();
        
        // Final update for stats and status [Sanket]
        $upload->update([
            'total_leads' => $stats['total'],
            'valid_leads' => $stats['valid'],
            'duplicate_leads' => $stats['duplicate'],
            'invalid_leads' => $stats['invalid'],
            'status' => 'completed',
        ]);

        $this->info("Seeding complete!");
        $this->table(['Total', 'Valid', 'Duplicate', 'Invalid'], [
            [$stats['total'], $stats['valid'], $stats['duplicate'], $stats['invalid']]
        ]);

        return 0;
    }
}
