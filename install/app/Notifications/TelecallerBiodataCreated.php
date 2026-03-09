<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class TelecallerBiodataCreated extends Notification
{
    use Queueable;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public $telecaller;
    public $user;

    public function __construct($telecaller, $user)
    {
        $this->telecaller = $telecaller;
        $this->user = $user;
    }

    public function via($notifiable)
    {
        return ['database'];
    }

    public function toArray($notifiable)
    {
        return [
            'type' => 'telecaller_biodata_created',
            'title' => 'New Biodata Entry',
            'message' => $this->telecaller->first_name . ' created a new profile for: ' . $this->user->first_name,
            'notify_by' => $this->telecaller->id,
            'route' => 'members.index', // Added route for notification_view compatibility [Sanket]
            'url' => route('members.show', encrypt($this->user->id))
        ];
    }
}
