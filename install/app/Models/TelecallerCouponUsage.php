<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TelecallerCouponUsage extends Model
{
    use HasFactory;

    protected $fillable = [
        'telecaller_id',
        'user_id',
        'coupon_code',
        'discount_amount',
        'commission_amount',
        'status'
    ];

    public function telecaller()
    {
        return $this->belongsTo(User::class, 'telecaller_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
