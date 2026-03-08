<?php

namespace App\Imports;

use App\Models\ActiveLead;
use App\Models\InactiveLead;
use App\Models\DuplicateLead;
use App\Models\LeadUpload;
use Maatwebsite\Excel\Concerns\OnEachRow;
use Maatwebsite\Excel\Concerns\WithChunkReading;
use Maatwebsite\Excel\Concerns\WithBatchInserts;
use Maatwebsite\Excel\Row;
use Auth;

class LeadsImport implements OnEachRow, WithChunkReading, WithBatchInserts
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
        $this->upload_id = $upload_id;
        $this->campaign_id = $campaign_id;
        $this->mapping = $mapping;
    }

    public function onRow(Row $row)
    {
        $rowIndex = $row->getIndex();
        if ($rowIndex == 1) return; // Skip header [Sanket]

        $rowArr = $row->toArray();
        $this->stats['total']++;

        // Sanket: Extract data using dynamic mapping
        $name   = isset($this->mapping['name']) ? ($rowArr[$this->mapping['name']] ?? null) : null;
        $email  = isset($this->mapping['email']) ? ($rowArr[$this->mapping['email']] ?? null) : null;
        $mobile = isset($this->mapping['mobile']) ? ($rowArr[$this->mapping['mobile']] ?? null) : null;
        $city   = isset($this->mapping['city']) ? ($rowArr[$this->mapping['city']] ?? null) : null;
        $pincode = isset($this->mapping['pincode']) ? ($rowArr[$this->mapping['pincode']] ?? null) : null;
        $source = isset($this->mapping['source']) ? ($rowArr[$this->mapping['source']] ?? null) : null;
        $business_type = isset($this->mapping['business_type']) ? ($rowArr[$this->mapping['business_type']] ?? null) : null;

        // Clean mobile
        $mobile = $mobile ? preg_replace('/[^0-9]/', '', (string)$mobile) : null;

        // 1. Validation: 10 digit mobile [Sanket]
        if (!$mobile || strlen($mobile) != 10) {
            $this->stats['invalid']++;
            $this->updateUploadStats();
            return;
        }

        // 2. Duplicate Detection [Sanket]
        $is_duplicate = ActiveLead::where('mobile', $mobile)->exists() || 
                       InactiveLead::where('mobile', $mobile)->exists();

        if ($is_duplicate) {
            $this->stats['duplicate']++;
            DuplicateLead::create([
                'mobile' => $mobile,
                'name' => $name,
                'data' => $rowArr,
                'upload_id' => $this->upload_id,
            ]);
            $this->updateUploadStats();
            return;
        }

        // 3. Valid Lead Creation [Sanket]
        ActiveLead::create([
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
        ]);

        $this->stats['valid']++;
        $this->updateUploadStats();
    }

    private function updateUploadStats()
    {
        // Periodic update to keep UI informed if needed, or just update at end [Sanket]
        // Since it's within current request, we'll update it silently.
        $upload = LeadUpload::find($this->upload_id);
        if ($upload) {
            $upload->update([
                'total_leads' => $this->stats['total'],
                'valid_leads' => $this->stats['valid'],
                'duplicate_leads' => $this->stats['duplicate'],
                'invalid_leads' => $this->stats['invalid'],
            ]);
        }
    }

    public function chunkSize(): int
    {
        return 1000; // Sanket: Process 1000 rows at a time to save memory
    }

    public function batchSize(): int
    {
        return 500;
    }

    public function getStats()
    {
        return $this->stats;
    }
}
