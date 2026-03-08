<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

// Sanket: Model for replies on a support ticket
class SupportTicketReply extends Model
{
    protected $fillable = [
        'support_ticket_id',
        'user_id',
        'reply',
    ];

    // Relationship back to the parent ticket
    public function ticket()
    {
        return $this->belongsTo(SupportTicket::class, 'support_ticket_id');
    }

    // Who wrote this reply
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
