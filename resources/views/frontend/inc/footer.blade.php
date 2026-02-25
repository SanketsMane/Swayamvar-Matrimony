<footer class="aiz-footer fs-13 mt-auto text-white fw-400" style="background-color: var(--color-maroon);">
    <div class="container py-5">

        @if (get_setting('footer_address') != null || get_setting('footer_website') != null || get_setting('footer_email') != null || get_setting('footer_phones') != null)
        <div class="mb-4">
            <h4 class="text-white text-uppercase border-bottom pb-2 mb-4 fs-16 fw-700" style="border-color: rgba(255,255,255,0.2) !important;">{{ translate('Contacts') }}</h4>
            <div class="row opacity-80 no-gutters">
                <div class="col-xl col-md-6 mb-4">
                    <div class="mb-2 fw-700">
                        <span>{{ translate('Address') }}</span>
                    </div>
                    <div class="fs-14">{!! translate(get_setting('footer_address')) !!}</div>
                </div>
                <div class="col-xl col-md-6 mb-4">
                    <div class="mb-2 fw-700">
                        <span>{{ translate('Website') }}</span>
                    </div>
                    <div class="fs-14">{{ get_setting('footer_website') }}</div>
                </div>
                <div class="col-xl col-md-6 mb-4">
                    <div class="mb-2 fw-700">
                        <span>{{ translate('Email') }}</span>
                    </div>
                    <div class="fs-14">{{ get_setting('footer_email') }}</div>
                </div>
                <div class="col-xl col-md-6 mb-4">
                    <div class="mb-2 fw-700">
                        <span>{{ translate('Phone') }}</span>
                    </div>
                    @if (get_setting('footer_phones') != null)
                        <div class="fs-14">
                        @foreach (json_decode(get_setting('footer_phones'), true) as $key => $value)
                            <div class="mb-1">{{ $value }}</div>
                        @endforeach
                        </div>
                    @endif
                </div>
            </div>
        </div>
        @endif

        <div class="row no-gutters">
            @if ( !empty(get_setting('widget_one_labels')) )
            <div class="col-xl col-md-6 mb-4">
                <h4 class="text-uppercase border-bottom pb-2 mb-4 fs-16 fw-700" style="border-color: rgba(255,255,255,0.2) !important;">{{ translate(get_setting('widget_one_title')) }}</h4>
                <div>
                    <ul class="list-unstyled">
                        @foreach (json_decode( get_setting('widget_one_labels'), true) as $key => $value)
                            <li class="my-2">
                                <a href="{{ json_decode( get_setting('widget_one_links'), true)[$key] }}" class="text-reset opacity-80 hover-opacity-100 fs-14 transition-all">{{ translate($value) }}</a>
                            </li>
                        @endforeach
                    </ul>
                </div>
            </div>
            @endif

            @if ( !empty(get_setting('widget_two_labels')) )
            <div class="col-xl col-md-6 mb-4">
                <h4 class="text-uppercase border-bottom pb-2 mb-4 fs-16 fw-700" style="border-color: rgba(255,255,255,0.2) !important;">{{ translate(get_setting('widget_two_title')) }}</h4>
                <div>
                    <ul class="list-unstyled">
                        @foreach (json_decode( get_setting('widget_two_labels'), true) as $key => $value)
                            <li class="my-2">
                                <a href="{{ json_decode( get_setting('widget_two_links'), true)[$key] }}" class="text-reset opacity-80 hover-opacity-100 fs-14 transition-all">{{ translate($value) }}</a>
                            </li>
                        @endforeach
                    </ul>
                </div>
            </div>
            @endif

            @if ( !empty(get_setting('widget_three_labels')) )
            <div class="col-xl col-md-6 mb-4">
                <h4 class="text-uppercase border-bottom pb-2 mb-4 fs-16 fw-700" style="border-color: rgba(255,255,255,0.2) !important;">{{ translate(get_setting('widget_three_title')) }}</h4>
                <div>
                    <ul class="list-unstyled">
                        @foreach (json_decode( get_setting('widget_three_labels'), true) as $key => $value)
                            <li class="my-2">
                                <a href="{{ json_decode( get_setting('widget_three_links'), true)[$key] }}" class="text-reset opacity-80 hover-opacity-100 fs-14 transition-all">{{ translate($value) }}</a>
                            </li>
                        @endforeach
                    </ul>
                </div>
            </div>
            @endif

            <div class="col-xl col-md-6 mb-4">
                <h4 class="text-uppercase border-bottom pb-2 mb-4 fs-16 fw-700 text-white" style="border-color: rgba(255,255,255,0.2) !important;">{{ translate('Download Our App') }}</h4>
                <div class="mb-3">
                    <a href="https://play.google.com/store" class="d-inline-block">
                        <img src="{{ static_asset('assets/img/google-play.svg') }}" height="45" alt="Get it on Google Play">
                    </a>
                </div>
                <div class="mb-3">
                    <a href="https://apple.com/app-store" class="d-inline-block">
                        <img src="{{ static_asset('assets/img/app-store.svg') }}" height="45" alt="Download on the App Store">
                    </a>
                </div>
            </div>
        </div>

        <div class="border-top pt-4 mt-2" style="border-color: rgba(255,255,255,0.2) !important;">
            <div class="row align-items-center">
                <div class="col-lg-6 mb-3 mb-lg-0">
                    <div class="fs-13 opacity-70" current-verison="{{get_setting("current_version")}}">
                        {!! translate(str_replace('<p>', '<p class="mb-0">', get_setting('footer_copyright_text'))) !!}
                    </div>
                </div>
                @if(get_setting('show_social_links') == 'on')
                <div class="col-lg-6">
                    <div class="text-center text-lg-right">
                        <span class="mr-3 fs-14 fw-700 opacity-80">{{ translate('Follow us on:') }}</span>
                        <ul class="list-inline mb-0 d-inline-block">
                            @if ( !empty(get_setting('facebook_link')) )
                                <li class="list-inline-item mr-3">
                                    <a href="{{ get_setting('facebook_link') }}" target="_blank" class="text-white opacity-80 hover-opacity-100 transition-all"><i class="lab la-facebook-f fs-20"></i></a>
                                </li>
                            @endif
                            @if ( !empty(get_setting('twitter_link')) )
                            <li class="list-inline-item mr-3">
                                <a href="{{ get_setting('twitter_link') }}" target="_blank" class="text-white opacity-80 hover-opacity-100 transition-all"><i class="lab la-twitter fs-20"></i></a>
                            </li>
                            @endif
                            @if ( !empty(get_setting('instagram_link')) )
                            <li class="list-inline-item mr-3">
                                <a href="{{ get_setting('instagram_link') }}" target="_blank" class="text-white opacity-80 hover-opacity-100 transition-all"><i class="lab la-instagram fs-20"></i></a>
                            </li>
                            @endif
                            @if ( !empty(get_setting('youtube_link')) )
                            <li class="list-inline-item mr-3">
                                <a href="{{ get_setting('youtube_link') }}" target="_blank" class="text-white opacity-80 hover-opacity-100 transition-all"><i class="lab la-youtube fs-20"></i></a>
                            </li>
                            @endif
                            @if ( !empty(get_setting('linkedin_link')) )
                            <li class="list-inline-item">
                                <a href="{{ get_setting('linkedin_link') }}" target="_blank" class="text-white opacity-80 hover-opacity-100 transition-all"><i class="lab la-linkedin-in fs-20"></i></a>
                            </li>
                            @endif
                        </ul>
                    </div>
                </div>
                @endif
            </div>
            

        </div>

    </div>
</footer>

<div class="aiz-mobile-bottom-nav d-xl-none fixed-bottom bg-white shadow-lg border-top rounded-top" style="box-shadow: 0px -1px 10px rgb(0 0 0 / 15%)!important; ">
    <div class="row align-items-center gutters-5 text-center">
        <div class="col">
            <a href="{{ route('home') }}" class="text-reset d-block flex-grow-1 text-center py-2">
                <i class="las la-home fs-18 opacity-60 {{ areActiveRoutes(['home'],'opacity-100')}}"></i>
                <span class="d-block fs-10 opacity-60 {{ areActiveRoutes(['home'],'opacity-100 fw-600')}}">{{ translate('Home') }}</span>
            </a>
        </div>
        <div class="col">
            <a href="{{ route('frontend.notifications') }}" class="text-reset d-block flex-grow-1 text-center py-2">
                <span class="d-inline-block position-relative px-2">
                    <i class="las la-bell fs-18 opacity-60 {{ areActiveRoutes(['frontend.notifications'],'opacity-100')}}"></i>
                    @if(Auth::check() && Auth::user()->user_type == 'member')
                        @php
                            $unseen_notification = \App\Models\Notification::where('notifiable_id',Auth()->user()->id)->where('read_at',null)->count();
                        @endphp
                        @if($unseen_notification > 0)
                            <span class="badge badge-sm badge-circle badge-primary position-absolute absolute-top-right">{{ $unseen_notification }}</span>
                        @endif
                    @endif
                </span>
                <span class="d-block fs-10 opacity-60 {{ areActiveRoutes(['frontend.notifications'],'opacity-100 fw-600')}}">{{ translate('Notifications') }}</span>
            </a>
        </div>
        <div class="col">
          <a href="{{ route('all.messages') }}" class="text-reset d-block flex-grow-1 text-center py-2 {{ areActiveRoutes(['all.messages'],'opacity-100')}}">
              <span class="d-inline-block position-relative px-2">
                  <i class="las la-comment-dots fs-18 opacity-60 {{ areActiveRoutes(['all.messages'],'opacity-100')}}"></i>
                    @if(Auth::check() && Auth::user()->user_type == 'member')
                        @php
                            $unseen_chat_thread_count = count(chat_threads());
                        @endphp
                        @if($unseen_chat_thread_count > 0)
                            <span class="badge badge-sm badge-circle badge-primary position-absolute absolute-top-right">{{ $unseen_chat_thread_count }}</span>
                        @endif
                    @endif
              </span>
              <span class="d-block fs-10 opacity-60 {{ areActiveRoutes(['all.messages'],'opacity-100 fw-600')}}">{{ translate('Messages') }}</span>
          </a>
        </div>
        @if (Auth::check())
            @if(Auth::user()->user_type == 'member')
                <div class="col">
                    <a href="javascript:void(0)" class="text-reset d-block flex-grow-1 text-center py-2 mobile-side-nav-thumb" data-toggle="class-toggle" data-target=".aiz-mobile-side-nav">
                        <span class="d-block mx-auto mb-1 opacity-60">
                            <img src="{{ uploaded_asset(Auth::user()->photo)}}" class="rounded-circle size-20px" onerror="this.onerror=null;this.src='{{ static_asset('assets/img/avatar-place.png') }}';">
                        </span>
                        <span class="d-block fs-10 opacity-60">{{ translate('Account') }}</span>
                    </a>
                </div>
            @else
                <div class="col">
                    <a href="{{ route('admin.dashboard') }}" class="text-reset d-block flex-grow-1 text-center py-2">
                        <span class="d-block mx-auto mb-1 opacity-60">
                            <img src="{{ uploaded_asset(Auth::user()->photo)}}" class="rounded-circle size-20px" onerror="this.onerror=null;this.src='{{ static_asset('assets/img/avatar-place.png') }}';">
                        </span>
                        <span class="d-block fs-10 opacity-60">{{ translate('Account') }}</span>
                    </a>
                </div>
            @endif
        @else
            <div class="col">
                <a href="{{ route('login') }}" class="text-reset d-block flex-grow-1 text-center py-2">
                    <span class="d-block mx-auto mb-1 opacity-60 {{ areActiveRoutes(['login'],'opacity-100')}}">
                        <img src="{{ static_asset('assets/img/avatar-place.png') }}" class="rounded-circle size-20px">
                    </span>
                    <span class="d-block fs-10 opacity-60 {{ areActiveRoutes(['login'],'opacity-100 fw-600')}}">{{ translate('Account') }}</span>
                </a>
            </div>
        @endif
    </div>
</div>

@if (Auth::check() && Auth::user()->user_type == 'member')
    <div class="aiz-mobile-side-nav collapse-sidebar-wrap sidebar-xl d-xl-none z-1035">
        <div class="overlay dark c-pointer overlay-fixed" data-toggle="class-toggle" data-target=".aiz-mobile-side-nav" data-same=".mobile-side-nav-thumb"></div>
        <div class="collapse-sidebar bg-white">
            @include('frontend.member.sidebar')
        </div>
    </div>
@endif