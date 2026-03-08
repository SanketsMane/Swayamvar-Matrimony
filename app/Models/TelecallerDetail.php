<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TelecallerDetail extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'pincode',
        'department',
        'state',
        'city',
        'coupon_code',
        'discount_percent',
        'commission_percent'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
