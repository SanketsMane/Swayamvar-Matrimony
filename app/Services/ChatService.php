<?php

namespace App\Services;

use App\Models\Chat;

class ChatService
{
      public function store(array $data, $attachments)
      {
            $attachment = null;
            $chat_thread_id = $data['chat_thread_id'];
            $sender_user_id = auth()->user()->id;
            $message = $data['message'] ?? "";
            
            if ($attachments != null) {
                  $attachment = implode(',', $attachments);
            }

            // Sanket: Only pass explicit fields to create to avoid "Column not found" errors with extra request data
            return Chat::create([
                  'chat_thread_id' => $chat_thread_id,
                  'sender_user_id' => $sender_user_id,
                  'message' => $message,
                  'attachment' => $attachment,
            ]);
      }
}
