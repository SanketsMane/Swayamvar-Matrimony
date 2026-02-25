<!-- Jeevansathi Solid Navbar -->
<nav class="nav-jeevansathi-solid @if(get_setting('header_stikcy') == 'on') position-fixed @endif">
    <div class="container">
        <div class="d-flex align-items-center justify-content-between">
            
            <!-- Logo / Brand -->
            <div class="logo">
                <a href="{{ route('home') }}" class="nav-modern-brand text-decoration-none">
                    @if(get_setting('header_logo') != null)
                        <img src="{{ uploaded_asset(get_setting('header_logo')) }}" alt="{{ env('APP_NAME') }}" class="mw-100 h-40px h-md-50px">
                    @else
                        Swayamvar
                    @endif
                </a>
            </div>

            <!-- Main Menu (Desktop) - Removed for now -->
            <div class="d-none d-lg-flex align-items-center">
            </div>

            <!-- Right Actions -->
            <div class="d-flex align-items-center">
                <!-- Language Selector -->
                @php
                    if(Session::has('locale')){
                        $locale = Session::get('locale', Config::get('app.locale'));
                    }
                    else{
                        $locale = env('DEFAULT_LANGUAGE');
                    }
                    $current_lang = \App\Models\Language::where('code', $locale)->first();
                @endphp
                <div class="dropdown mr-4" id="lang-change">
                    <a href="javascript:void(0)" class="dropdown-toggle text-dark d-flex align-items-center text-decoration-none fw-600" data-toggle="dropdown" style="font-size: 14px;">
                        @if($current_lang != null)
                            <span class="d-none d-md-inline-block">{{ $current_lang->name }}</span>
                        @endif
                    </a>
                    <div class="dropdown-menu dropdown-menu-right mt-3 shadow border-0 rounded-12 overflow-hidden">
                        @foreach (\App\Models\Language::all() as $key => $language)
                            <a href="javascript:void(0)" data-flag="{{ $language->code }}" class="dropdown-item @if($locale == $language->code) bg-light fw-700 @endif py-2" onclick="changeLanguage('{{ $language->code }}')">
                                <span class="language">{{ $language->name }}</span>
                            </a>
                        @endforeach
                    </div>
                </div>
                @if (Auth::check())
                    <div class="dropdown">
                        <a href="javascript:void(0)" class="dropdown-toggle text-white d-flex align-items-center text-decoration-none" data-toggle="dropdown">
                            <img src="{{ uploaded_asset(Auth::user()->photo) }}"
                                class="size-35px rounded-circle img-fit mr-2 border border-white"
                                onerror="this.onerror=null;this.src='{{ static_asset('assets/img/avatar-place.png') }}';">
                            <span class="d-none d-md-inline-block fw-600">{{ Auth::user()->name }}</span>
                        </a>
                        <div class="dropdown-menu dropdown-menu-right mt-3 shadow-lg border-0 rounded-12">
                            <a class="dropdown-item py-2" href="{{ route('dashboard') }}"><i class="las la-th-large mr-2"></i>{{ translate('Dashboard') }}</a>
                            <a class="dropdown-item py-2" href="{{ route('profile_settings') }}"><i class="las la-user mr-2"></i>{{ translate('My Profile') }}</a>
                            <a class="dropdown-item py-2" href="{{ route('logout') }}"><i class="las la-sign-out-alt mr-2"></i>{{ translate('Logout') }}</a>
                        </div>
                    </div>
                @else
                    <a href="{{ route('login') }}" class="nav-jeevansathi-login text-decoration-none">{{ translate('Login') }}</a>
                    <a href="{{ route('register') }}" class="btn-jeevansathi-register text-decoration-none d-none d-md-inline-block">{{ translate('Register for Free') }}</a>
                @endif

                <!-- Mobile Toggle -->
                <button class="navbar-toggler d-lg-none ml-3 text-dark border-0" type="button" data-toggle="collapse" data-target="#modern-mobile-nav">
                    <i class="las la-bars la-2x"></i>
                </button>
            </div>
        </div>
    </div>

    <!-- Mobile Navigation -->
    <div class="collapse d-lg-none" id="modern-mobile-nav">
        <div class="p-4 glass-register-card m-3 border-0" style="border-radius: 20px;">
            <ul class="navbar-nav">
                <!-- Mobile Menu Links Removed for now -->
                <!-- Mobile Language Selector -->
                <li class="nav-item mb-3">
                    <div class="dropdown" id="lang-change-mobile">
                        <a href="javascript:void(0)" class="dropdown-toggle nav-link text-white fw-600 d-flex align-items-center" data-toggle="dropdown">
                            @if($current_lang != null)
                                <span>{{ $current_lang->name }}</span>
                            @endif
                        </a>
                        <div class="dropdown-menu mt-2 shadow border-0 rounded-12 overflow-hidden">
                            @foreach (\App\Models\Language::all() as $key => $language)
                                <a href="javascript:void(0)" data-flag="{{ $language->code }}" class="dropdown-item @if($locale == $language->code) bg-light fw-700 @endif py-2" onclick="changeLanguage('{{ $language->code }}')">
                                    <span class="language">{{ $language->name }}</span>
                                </a>
                            @endforeach
                        </div>
                    </div>
                </li>
                @if (!Auth::check())
                    <li class="nav-item mt-3">
                        <a href="{{ route('register') }}" class="btn-nav-register d-block text-center">{{ translate('Register Now') }}</a>
                    </li>
                @endif
            </ul>
        </div>
    </div>
</nav>

<form id="lang-form" action="{{ route('language.change') }}" method="POST" style="display:none;">
    @csrf
    <input type="hidden" name="locale" id="lang-input">
</form>

<script>
    function changeLanguage(locale) {
        document.getElementById('lang-input').value = locale;
        document.getElementById('lang-form').submit();
    }
</script>
