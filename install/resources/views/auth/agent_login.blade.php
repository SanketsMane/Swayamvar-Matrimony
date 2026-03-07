@extends('admin.layouts.blank')

@section('content')

<div class="h-100 bg-cover bg-center py-5 d-flex align-items-center" style="background-image: url({{ uploaded_asset(get_setting('admin_login_background')) }})">
    <div class="container">
        <div class="row">
            <div class="col-lg-6 col-xl-5 col-xxl-4 mx-auto">
                <div class="card text-left border-0 shadow-lg">
                    <div class="card-body p-4">
                        <div class="mb-5 text-center">
                            <img src="{{ uploaded_asset(get_setting('system_logo_black')) }}" class="mw-100 mb-4" height="40">
                            <h1 class="h3 text-primary mb-0">{{ translate('Agent Portal') }}</h1>
                            <p class="text-muted">{{ translate('Login to manage your leads.') }}</p>
                        </div>
                        <form class="pad-hor" method="POST" role="form" action="{{ route('agent.login') }}">
                            @csrf
                            <div class="form-group">
                                <label class="fs-12 fw-600 text-muted">{{ translate('Email or Phone') }}</label>
                                <input id="email" type="text" class="form-control{{ $errors->has('email') ? ' is-invalid' : '' }}" name="email" value="{{ old('email') }}" required autofocus placeholder="{{ translate('Email or Phone') }}">
                                @if ($errors->has('email'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('email') }}</strong>
                                    </span>
                                @endif
                            </div>
                            <div class="form-group">
                                <label class="fs-12 fw-600 text-muted">{{ translate('Password') }}</label>
                                <input id="password" type="password" class="form-control{{ $errors->has('password') ? ' is-invalid' : '' }}" name="password" required placeholder="{{ translate('Password') }}">
                                @if ($errors->has('password'))
                                    <span class="invalid-feedback" role="alert">
                                        <strong>{{ $errors->first('password') }}</strong>
                                    </span>
                                @endif
                            </div>
                            <div class="row mb-3">
                                <div class="col-sm-6">
                                    <div class="text-left">
                                        <label class="aiz-checkbox">
                                            <input type="checkbox" name="remember" id="remember" {{ old('remember') ? 'checked' : '' }}>
                                            <span class="fs-13 text-muted">{{ translate('Remember Me') }}</span>
                                            <span class="aiz-square-check"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary btn-lg btn-block shadow-sm">
                                {{ translate('Login as Agent') }}
                            </button>
                        </form>
                        <div class="mt-4 text-center">
                            <a href="{{ route('home') }}" class="text-muted fs-14">
                                <i class="las la-arrow-left"></i> {{ translate('Back to Website') }}
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
