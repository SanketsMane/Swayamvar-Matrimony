<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DuplicateLead extends Model
{
    use HasFactory;

    protected $fillable = [
        'mobile',
        'name',
        'data',
        'upload_id'
    ];

    protected $casts = [
        'data' => 'array'
    ];

    public function getMappingValue($field)
    {
        $mapping = $this->upload->column_mapping or [];
        if (isset($mapping[$field])) {
            $index = $mapping[$field];
            return $this->data[$index] ?? null;
        }
        return null;
    }

    public function getExistingLead()
    {
        return ActiveLead::where('mobile', $this->mobile)->first();
    }

    public function upload()
    {
        return $this->belongsTo(LeadUpload::class, 'upload_id');
    }
}
