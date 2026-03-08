<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

// Sanket: Lookup model for support ticket categories
class SupportTicketCategory extends Model
{
    protected $table = 'support_ticket_categories';

    protected $fillable = [
        'name',
    ];

    // One category can have many tickets
    public function tickets()
    {
        return $this->hasMany(SupportTicket::class, 'category_id');
    }
}
