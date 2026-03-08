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

    public function upload()
    {
        return $this->belongsTo(LeadUpload::class, 'upload_id');
    }
}
