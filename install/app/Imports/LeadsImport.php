<?php

namespace App\Imports;

use App\Models\ActiveLead;
use App\Models\InactiveLead;
use App\Models\DuplicateLead;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use Maatwebsite\Excel\Concerns\WithReadFilter;
use PhpOffice\PhpSpreadsheet\Reader\IReadFilter;
use Auth;
use Carbon\Carbon;

class LeadsImport implements ToCollection, WithChunkReading, WithReadFilter
{
    private $upload_id;
    private $campaign_id;
    private $mapping; 
    private $stats = [
        'total'     => 0,
        'valid'     => 0,
        'duplicate' => 0,
        'invalid'   => 0,
    ];

    public function __construct($upload_id, $campaign_id, $mapping = [])
    {
        \Log::info("LeadsImport started for upload_id: $upload_id");
        $this->upload_id = $upload_id;
        $this->campaign_id = $campaign_id;
        $this->mapping = $mapping;
    }

    public function readFilter(): IReadFilter
    {
        return new class implements IReadFilter {
            public function readCell($columnAddress, $row, $worksheetName = '') {
                return true; 
            }
        };
    }

    public function collection(Collection $rows)
    {
        $now = Carbon::now();
        $chunkLeads = [];
        $chunkDuplicates = [];
        $mobilesInChunk = [];
        $rowIndices = [];

        // 1. Extract and validate mobiles from the chunk
        foreach ($rows as $index => $row) {
            // Skip header only in the very first row of the very first chunk
            if ($this->stats['total'] == 0 && $index == 0) continue; 

            $rowArr = $row->toArray();
            $mobile = isset($this->mapping['mobile']) ? ($rowArr[$this->mapping['mobile']] ?? null) : null;
            $mobile = $mobile ? preg_replace('/[^0-9]/', '', (string)$mobile) : null;

            $this->stats['total']++;

            if (!$mobile || strlen($mobile) != 10) {
                $this->stats['invalid']++;
                continue;
            }

            $mobilesInChunk[$index] = $mobile;
            $rowIndices[] = $index;
        }

        if (empty($mobilesInChunk)) return;

        // 2. Perform ONE bulk existence check for all 500 rows
        $mobileValues = array_values($mobilesInChunk);
        $existingActive = ActiveLead::whereIn('mobile', $mobileValues)->pluck('mobile')->toArray();
        $existingInactive = InactiveLead::whereIn('mobile', $mobileValues)->pluck('mobile')->toArray();
        $allExisting = array_flip(array_merge($existingActive, $existingInactive));

        // 3. Process the chunk data
        foreach ($mobilesInChunk as $index => $mobile) {
            $rowArr = $rows[$index]->toArray();
            
            $name   = isset($this->mapping['name']) ? ($rowArr[$this->mapping['name']] ?? null) : null;
            $email  = isset($this->mapping['email']) ? ($rowArr[$this->mapping['email']] ?? null) : null;
            $city   = isset($this->mapping['city']) ? ($rowArr[$this->mapping['city']] ?? null) : null;
            $pincode = isset($this->mapping['pincode']) ? ($rowArr[$this->mapping['pincode']] ?? null) : null;
            $source = isset($this->mapping['source']) ? ($rowArr[$this->mapping['source']] ?? null) : null;
            $business_type = isset($this->mapping['business_type']) ? ($rowArr[$this->mapping['business_type']] ?? null) : null;

            if (isset($allExisting[$mobile])) {
                $this->stats['duplicate']++;
                $chunkDuplicates[] = [
                    'mobile' => $mobile,
                    'name' => $name,
                    'data' => json_encode($rowArr),
                    'upload_id' => $this->upload_id,
                    'created_at' => $now,
                    'updated_at' => $now,
                ];
            } else {
                $this->stats['valid']++;
                $chunkLeads[] = [
                    'name' => $name,
                    'mobile' => $mobile,
                    'email' => $email,
                    'city' => $city,
                    'pincode' => $pincode,
                    'source' => $source,
                    'business_type' => $business_type,
                    'campaign_id' => $this->campaign_id,
                    'upload_id' => $this->upload_id,
                    'status' => 'New',
                    'created_at' => $now,
                    'updated_at' => $now,
                ];
            }
        }

        // 4. Batch Insert Valid and Duplicates
        if (!empty($chunkLeads)) {
            ActiveLead::insert($chunkLeads);
        }
        if (!empty($chunkDuplicates)) {
            DuplicateLead::insert($chunkDuplicates);
        }

        // 5. Update Progress in DB for Progress Bar [Sanket]
        \DB::table('lead_uploads')->where('id', $this->upload_id)->increment('processed_rows', count($rows));
        
        \Log::info("LeadsImport processed chunk. Current total: {$this->stats['total']}");
    }

    public function chunkSize(): int
    {
        return 500;
    }

    public function getStats()
    {
        return $this->stats;
    }
}
