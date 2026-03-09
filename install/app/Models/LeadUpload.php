<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LeadUpload extends Model
{
    use HasFactory;

    protected $fillable = [
        'file_name',
        'total_leads',
        'valid_leads',
        'duplicate_leads',
        'invalid_leads',
        'campaign_id',
        'user_id',
        'total_rows',
        'processed_rows',
        'column_mapping',
        'status'
    ];

    protected $casts = [
        'column_mapping' => 'array'
    ];

    public function campaign()
    {
        return $this->belongsTo(TelecallingCampaign::class, 'campaign_id');
    }

    public function uploader()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function leads()
    {
        return $this->hasMany(ActiveLead::class, 'upload_id');
    }
}
