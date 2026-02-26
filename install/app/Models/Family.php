<?php

namespace App\Models;
use App\Models\User;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Family extends Model
{
    protected $guarded = [];
    use SoftDeletes;

    public function user()
    {
        return $this->belongsTo(User::class)->withTrashed();
    }
}
