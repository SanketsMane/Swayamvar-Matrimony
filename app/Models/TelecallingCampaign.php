<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class TelecallingCampaign extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'name',
        'description',
        'status'
    ];

    public function leads()
    {
        return $this->hasMany(ActiveLead::class, 'campaign_id');
    }

    public function inactive_leads()
    {
        return $this->hasMany(InactiveLead::class, 'campaign_id');
    }

    public function uploads()
    {
        return $this->hasMany(LeadUpload::class, 'campaign_id');
    }
}
