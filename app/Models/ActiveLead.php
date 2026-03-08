<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class ActiveLead extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'name',
        'mobile',
        'email',
        'city',
        'pincode',
        'source',
        'business_type',
        'notes',
        'custom_fields',
        'campaign_id',
        'upload_id',
        'assigned_to',
        'status',
        'last_call_at'
    ];

    protected $casts = [
        'custom_fields' => 'array',
        'last_call_at' => 'datetime'
    ];

    public function campaign()
    {
        return $this->belongsTo(TelecallingCampaign::class, 'campaign_id');
    }

    public function upload()
    {
        return $this->belongsTo(LeadUpload::class, 'upload_id');
    }

    public function assigned_agent()
    {
        return $this->belongsTo(User::class, 'assigned_to');
    }

    public function call_logs()
    {
        return $this->hasMany(TelecallingCallLog::class, 'lead_id')->where('lead_type', 'active_lead');
    }

    public function followups()
    {
        return $this->hasMany(TelecallingFollowup::class, 'lead_id');
    }
}
