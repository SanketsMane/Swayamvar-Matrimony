<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TelecallingCallLog extends Model
{
    use HasFactory;

    protected $fillable = [
        'lead_id',
        'lead_type',
        'agent_id',
        'status',
        'notes',
        'duration',
        'outcome',
        'call_time'
    ];

    protected $casts = [
        'call_time' => 'datetime'
    ];

    public function agent()
    {
        return $this->belongsTo(User::class, 'agent_id');
    }

    public function lead()
    {
        return $this->morphTo(null, 'lead_type', 'lead_id');
    }
}
