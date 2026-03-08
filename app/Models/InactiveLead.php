<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class InactiveLead extends Model
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
        'reason',
        'marked_inactive_by',
        'previous_agent_id'
    ];

    protected $casts = [
        'custom_fields' => 'array'
    ];

    public function campaign()
    {
        return $this->belongsTo(TelecallingCampaign::class, 'campaign_id');
    }

    public function upload()
    {
        return $this->belongsTo(LeadUpload::class, 'upload_id');
    }

    public function marked_by()
    {
        return $this->belongsTo(User::class, 'marked_inactive_by');
    }

    public function previous_agent()
    {
        return $this->belongsTo(User::class, 'previous_agent_id');
    }

    public function call_logs()
    {
        return $this->hasMany(TelecallingCallLog::class, 'lead_id')->where('lead_type', 'inactive_lead');
    }
}
