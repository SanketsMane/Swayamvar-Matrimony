<?php

namespace App\Http\Controllers\Agent\Auth;

use App\Http\Controllers\Controller;
use App\Providers\RouteServiceProvider;
use Illuminate\Foundation\Auth\AuthenticatesUsers;
use Illuminate\Http\Request;
use Auth;

class LoginController extends Controller
{
    use AuthenticatesUsers;

    protected $redirectTo = '/admin/telecalling/dashboard';

    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }

    public function showLoginForm()
    {
        return view('auth.agent_login');
    }

    protected function authenticated(Request $request, $user)
    {
        if ($user->user_type == 'telecaller') {
            return redirect()->route('telecalling.dashboard');
        }

        Auth::logout();
        flash(translate('Access denied. Only telecallers can login here.'))->error();
        return redirect()->route('agent.login');
    }

    public function logout(Request $request)
    {
        $this->guard()->logout();
        $request->session()->invalidate();
        return redirect()->route('agent.login');
    }
}
