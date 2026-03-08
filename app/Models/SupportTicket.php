<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

// Sanket: Model for support tickets created by members/users
class SupportTicket extends Model
{
    protected $fillable = [
        'user_id',
        'category_id',
        'subject',
        'description',
        'status',
        'assigned_agent_id',
        'priority',
    ];

    // Relationship to the ticket submitter
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    // Relationship to the assigned telecaller/agent
    public function assignedAgent()
    {
        return $this->belongsTo(User::class, 'assigned_agent_id');
    }

    // One ticket can have many replies
    public function replies()
    {
        return $this->hasMany(SupportTicketReply::class, 'support_ticket_id');
    }

    // Category of the ticket
    public function category()
    {
        return $this->belongsTo(SupportTicketCategory::class, 'category_id');
    }
}
