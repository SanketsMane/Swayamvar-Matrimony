<?php

namespace App\Http\Controllers\Api\Telecalling;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\SupportTicket;
use App\Models\SupportTicketCategory;
use Auth;

class TelecallerSupportApiController extends Controller
{
    public function getTickets(Request $request)
    {
        try {
            $user_id = Auth::id();

            // Sanket: Fetch support tickets created by this telecaller
            $tickets = SupportTicket::where('user_id', $user_id)
                ->latest()
                ->paginate(15);

            return response()->json([
                'result'       => true,
                'data'         => $tickets->items(),
                'current_page' => $tickets->currentPage(),
                'last_page'    => $tickets->lastPage()
            ]);
        } catch (\Throwable $e) {
            return response()->json(['result' => false, 'message' => 'Failed to load tickets: ' . $e->getMessage()], 500);
        }
    }

    public function reply(Request $request, $id)
    {
        $request->validate([
            'reply' => 'required|string',
        ]);

        $user_id = Auth::id();
        $ticket = SupportTicket::where('id', $id)->where('assigned_agent_id', $user_id)->first();

        if (!$ticket) {
            return response()->json(['result' => false, 'message' => 'Ticket not found'], 404);
        }

        // Create reply [Using existing pattern from project]
        $ticket_reply = new \App\Models\SupportTicketReply();
        $ticket_reply->support_ticket_id = $id;
        $ticket_reply->user_id = $user_id;
        $ticket_reply->reply = $request->reply;
        $ticket_reply->save();

        $ticket->status = 'replied';
        $ticket->save();

        return response()->json([
            'result' => true,
            'message' => 'Reply sent successfully'
        ]);
    }
}
// Sanket
