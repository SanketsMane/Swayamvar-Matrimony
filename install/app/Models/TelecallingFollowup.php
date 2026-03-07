<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TelecallingFollowup extends Model
{
    use HasFactory;

    protected $fillable = [
        'lead_id',
        'agent_id',
        'followup_date',
        'notes',
        'status'
    ];

    protected $casts = [
        'followup_date' => 'datetime'
    ];

    public function lead()
    {
        return $this->belongsTo(ActiveLead::class, 'lead_id');
    }

    public function agent()
    {
        return $this->belongsTo(User::class, 'agent_id');
    }
}
