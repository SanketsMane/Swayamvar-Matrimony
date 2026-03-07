<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class TelecallerAccountCreated extends Mailable
{
    use Queueable, SerializesModels;

    public $user;
    public $password;
    public $url;

    public function __construct($user, $password)
    {
        $this->user = $user;
        $this->password = $password;
        $this->url = url('/admin');
    }

    public function build()
    {
        return $this->subject(translate('Telecaller Account Created'))
                    ->view('emails.telecaller_account_created');
    }
}
