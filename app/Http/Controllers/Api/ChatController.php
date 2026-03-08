<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Api\Controller;
use App\Http\Requests\ChatRequest;
use App\Http\Resources\ChatResource;
use App\Http\Resources\ChatThreadResource;
use App\Http\Resources\MatchedProfileResource;
use App\Models\Chat;
use App\Models\ChatThread;
use App\Models\IgnoredUser;
use App\Models\ProfileMatch;
use App\Services\ChatService;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    public function chat_list()
    {
        // Sanket: Eager load relations to prevent N+1 queries in ChatThreadResource
        $chat_threads = ChatThread::where('sender_user_id', auth()->user()->id)
            ->orWhere('receiver_user_id', auth()->user()->id)
            ->with(['sender.member.package', 'receiver.member.package'])
            ->latest()
            ->get();

        return  ChatThreadResource::collection($chat_threads)->additional([
            'result' => true,
        ]);
    }

    public function chat_view(Request $request, $id)
    {
        // Sanket: Handle missing chat_thread_id by dynamically finding/creating one using user_id
        if ($id === 'null' && $request->has('user_id')) {
            $user_id = $request->user_id;
            $chat_thread = ChatThread::where(function ($query) use ($user_id) {
                $query->where('sender_user_id', auth()->user()->id)->where('receiver_user_id', $user_id);
            })->orWhere(function ($query) use ($user_id) {
                $query->where('receiver_user_id', auth()->user()->id)->where('sender_user_id', $user_id);
            })->first();

            if (!$chat_thread) {
                $chat_thread = new ChatThread;
                $chat_thread->thread_code = auth()->user()->id . date('Ymd') . $user_id;
                $chat_thread->sender_user_id = auth()->user()->id;
                $chat_thread->receiver_user_id = $user_id;
                $chat_thread->save();
            }
        } else {
            $chat_thread = ChatThread::findOrFail($id);
        }

        // Sanket: Security check - ensure authenticated user is part of this thread
        if ($chat_thread->sender_user_id != auth()->user()->id && $chat_thread->receiver_user_id != auth()->user()->id) {
            return response()->json(['result' => false, 'message' => 'Unauthorized access to this chat.'], 403);
        }

        // Sanket: Efficient bulk update for seen status instead of a loop
        Chat::where('chat_thread_id', $chat_thread->id)
            ->where('sender_user_id', '!=', auth()->user()->id)
            ->where('seen', 0)
            ->update(['seen' => 1]);

        return (new ChatResource($chat_thread))->additional([
                'result' => true
            ]);
    }

    public function get_old_messages(Request $request)
    {
        $chat = Chat::findOrFail($request->first_message_id);
        $chat_thread = ChatThread::findOrFail($chat->chat_thread_id);

        // Sanket: Security check - ensure authenticated user is part of this thread
        if ($chat_thread->sender_user_id != auth()->user()->id && $chat_thread->receiver_user_id != auth()->user()->id) {
            return response()->json(['result' => false, 'message' => 'Unauthorized access.'], 403);
        }

        $chats = Chat::where('id', '<', $chat->id)->where('chat_thread_id', $chat->chat_thread_id)->latest()->limit(20)->get();
        if(count($chats) > 0){
            return response()->json([
                'result' => true,
                'messages' => $chats,
                'first_message_id' => $chats->last()->id
            ]);            
        }
        else {
            return response()->json([
                'result' => false,
                'messages' => "",
                'first_message_id' => 0
            ]);            
        }
    }

    public function chat_reply(ChatRequest $request)
    {
        // image upload
        $attachments = [];
        if ($request->hasFile('attachment')) {
            foreach ($request->file('attachment') as $file) {
                $attachment = upload_api_file($file);
                $attachments[] = $attachment;
            }
        }

        $request_data = $request->except(['_token']);

        // Sanket: Retrieve or create a ChatThread if the flutter app sends "null"
        if ($request->chat_thread_id === 'null' && $request->has('receiver_user_id')) {
            $user_id = $request->receiver_user_id;
            $chat_thread = ChatThread::where(function ($query) use ($user_id) {
                $query->where('sender_user_id', auth()->user()->id)->where('receiver_user_id', $user_id);
            })->orWhere(function ($query) use ($user_id) {
                $query->where('receiver_user_id', auth()->user()->id)->where('sender_user_id', $user_id);
            })->first();

            if (!$chat_thread) {
                $chat_thread = new ChatThread;
                $chat_thread->thread_code = auth()->user()->id . date('Ymd') . $user_id;
                $chat_thread->sender_user_id = auth()->user()->id;
                $chat_thread->receiver_user_id = $user_id;
                $chat_thread->save();
            }
            $request_data['chat_thread_id'] = $chat_thread->id;
        } else {
            $chat_thread = ChatThread::findOrFail($request->chat_thread_id);
        }

        // Sanket: Blocked Chat Check
        if ($chat_thread->blocked_by_user != null) {
            return response()->json(['result' => false, 'message' => 'This chat has been blocked.'], 403);
        }

        // Sanket: Ignore List Check (Prevent ignored users from messaging)
        $other_user_id = ($chat_thread->sender_user_id == auth()->user()->id) ? $chat_thread->receiver_user_id : $chat_thread->sender_user_id;
        $is_ignored = \App\Models\IgnoredUser::where('user_id', auth()->user()->id)
            ->where('ignored_by', $other_user_id)
            ->exists();

        if ($is_ignored) {
            return response()->json(['result' => false, 'message' => 'You cannot send messages to this member.'], 403);
        }

        $chat_service = new ChatService();
        $new_chat = $chat_service->store($request_data, $attachments);

        // Trigger real-time event
        try {
            event(new \App\Events\MessageSent($new_chat));
        } catch (\Exception $e) {
            // Silently fail if broadcasting is not configured
        }

        return $this->success_message('Data inserted successfully!');
    }
}
