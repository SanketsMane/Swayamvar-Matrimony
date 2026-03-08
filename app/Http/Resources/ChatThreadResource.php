<?php

namespace App\Http\Resources;

use App\Models\IgnoredUser;
use App\Models\Member;
use App\Models\Package;
use App\Models\ProfileMatch;
use App\Models\User;
use Cache;
use Carbon\Carbon;
use Illuminate\Http\Resources\Json\JsonResource;

class ChatThreadResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        $user = auth()->user();
        if ($this->receiver != null && $this->sender != null) {
            $user_to_show = $user->id == $this->sender->id ? 'receiver' : 'sender';
            $other_user = $this->$user_to_show;
            $member = $other_user->member;
            $member_package = $member ? $member->package : null;

            // Sanket: Fetch the last chat securely without loading all history
            $last_chat = $this->chats()->latest()->first();

            return [
                'id' => $this->id,
                'user_id' => $other_user->id,
                // 'active' => $this->active,
                'active' => Cache::has('user-is-online-' . $other_user->id) ? 1 : 0,
                'blocked_by_user' => $this->blocked_by_user,
                // Sanket: Optimize unseen count query to run securely on DB directly
                'unseen_message_count' => $this->chats()->where('seen', 0)->where('sender_user_id', '!=', $user->id)->count(),
                'member_photo' => $other_user->photo != null ? uploaded_asset($other_user->photo) : static_asset('assets/frontend/default/img/avatar-place.png'),
                'member_name' => $other_user->first_name . ' ' . $other_user->last_name,
                'last_message_time' => $last_chat != null ? Carbon::parse($last_chat->created_at)->diffForHumans() : '',
                'last_message' => $last_chat ? $last_chat->message  : '',
                'member_package' => $member_package ? new PackageResource($member_package) : '',
            ];
        }
    }
}
