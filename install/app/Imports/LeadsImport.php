<?php

namespace App\Imports;

use App\Models\ActiveLead;
use App\Models\InactiveLead;
use App\Models\DuplicateLead;
use App\Models\LeadUpload;
use Maatwebsite\Excel\Concerns\ToCollection;
use Illuminate\Support\Collection;
use Auth;

class LeadsImport implements ToCollection
{
    private $upload_id;
    private $campaign_id;
    private $mapping; // Sanket: Dynamic column mapping
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

    public function collection(Collection $rows)
    {
        foreach ($rows as $key => $row) {
            if ($key == 0) continue; // Skip header

            $this->stats['total']++;

            // Sanket: Extract data using dynamic mapping
            $name   = isset($this->mapping['name']) ? ($row[$this->mapping['name']] ?? null) : null;
            $email  = isset($this->mapping['email']) ? ($row[$this->mapping['email']] ?? null) : null;
            $mobile = isset($this->mapping['mobile']) ? ($row[$this->mapping['mobile']] ?? null) : null;
            $city   = isset($this->mapping['city']) ? ($row[$this->mapping['city']] ?? null) : null;
            $pincode = isset($this->mapping['pincode']) ? ($row[$this->mapping['pincode']] ?? null) : null;
            $source = isset($this->mapping['source']) ? ($row[$this->mapping['source']] ?? null) : null;
            $business_type = isset($this->mapping['business_type']) ? ($row[$this->mapping['business_type']] ?? null) : null;

            // Clean mobile
            $mobile = $mobile ? preg_replace('/[^0-9]/', '', (string)$mobile) : null;

            // 1. Validation: 10 digit mobile [Sanket]
            if (!$mobile || strlen($mobile) != 10) {
                $this->stats['invalid']++;
                continue;
            }

            // 2. Duplicate Detection [Sanket]
            $is_duplicate = ActiveLead::where('mobile', $mobile)->exists() || 
                           InactiveLead::where('mobile', $mobile)->exists();

            if ($is_duplicate) {
                $this->stats['duplicate']++;
                DuplicateLead::create([
                    'mobile' => $mobile,
                    'name' => $name,
                    'data' => $row->toArray(),
                    'upload_id' => $this->upload_id,
                ]);
                continue;
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
        }

        // Update upload stats
        $upload = LeadUpload::find($this->upload_id);
        $upload->update([
            'total_leads' => $this->stats['total'],
            'valid_leads' => $this->stats['valid'],
            'duplicate_leads' => $this->stats['duplicate'],
            'invalid_leads' => $this->stats['invalid'],
        ]);
    }

    public function getStats()
    {
        return $this->stats;
    }
}
