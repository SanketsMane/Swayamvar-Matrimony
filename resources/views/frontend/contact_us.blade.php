@extends('frontend.layouts.app')

@section('content')
    <div class="container">
        <div class="contact-us">
            <div class="row">
                <div class="col-md-6 offset-md-3">
                    <div class="contact-us my-5">
                        <h2 class="text-center mb-4">{{ translate('Can we help you?') }}</h2>
                        <div class="card">
                            <div class="card-body">
                                @if ($errors->any())
                                    @foreach ($errors->all() as $error)
                                        <div class="text-danger my-2 font-weight-bold">{{ $error }}</div>
                                    @endforeach
                                @endif
                                <form action="{{ route('contact-us.store') }}" method="post">
                                    @csrf
                                    <div class="mb-3">
                                        <label class="form-label text-primary-grad"> {{ translate('Name') }} <span
                                                class="text-danger">*</span> </label>
                                        <input type="text" class="form-control" name="name"
                                            placeholder="{{ translate('Enter your full name') }}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label text-primary-grad"> {{ translate('Email') }} <span
                                                class="text-danger">*</span></label>
                                        <input type="email" class="form-control" name="email"
                                            placeholder="{{ translate('Enter Your E-mail') }}" required>
                                        <div class="form-text">
                                            {{ translate('Please, enter the email address where you wish to receive our answer.') }}
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label text-primary-grad"> {{ translate('Subject') }} <span
                                                class="text-danger">*</span> </label>
                                        <input type="text" class="form-control" name="subject"
                                            placeholder="{{ translate('Write the subject here') }}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label text-primary-grad"> {{ translate('Description') }} <span
                                                class="text-danger">*</span> </label>
                                        <textarea class="form-control" rows="8" placeholder=" {{ translate('Write your description here') }}"
                                            name="description" required style="resize: none;"></textarea>
                                    </div>
                                    @if(get_setting('google_recaptcha_activation') == 1)
                                        <div class="form-group">
                                            <div class="g-recaptcha" data-sitekey="{{ env('CAPTCHA_KEY') }}"></div>
                                            @error('g-recaptcha-response')
                                                <span class="invalid-feedback" role="alert">{{ $message }}</span>
                                            @enderror
                                        </div>
                                    @endif
                                    <button type="submit"
                                        class="btn btn-block btn-primary">{{ translate('Send') }}</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('script')
	@if(get_setting('google_recaptcha_activation') == 1)
		@include('partials.recaptcha')
	@endif
@endsection
