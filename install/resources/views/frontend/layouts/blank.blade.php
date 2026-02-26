@php
    if(Session::has('locale')){
        $locale = Session::get('locale', Config::get('app.locale'));
    }
    else{
        $locale = env('DEFAULT_LANGUAGE');
    }
    $lang = \App\Models\Language::where('code', $locale)->first();
@endphp

<!DOCTYPE html>
@if(\App\Models\Language::where('code', Session::get('locale', Config::get('app.locale')))->first()->rtl == 1)
<html dir="rtl" lang="{{ str_replace('_', '-', app()->getLocale()) }}">
@else
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
@endif

<head>
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <meta name="app-url" content="{{ env('APP_URL')}}">

    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Favicon -->
    <link rel="icon" href="{{ uploaded_asset(get_setting('site_icon')) }}">

  	<!-- Title -->
    <title>@yield('meta_title', get_setting('website_name').' | '.get_setting('site_motto'))</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- CSS -->
    <link rel="stylesheet" href="{{ static_asset('assets/css/vendors.css') }}">
    <link rel="stylesheet" href="{{ static_asset('assets/css/aiz-core.css') }}">
    <link rel="stylesheet" href="{{ static_asset('assets/css/marathi-theme.css') }}">

    <script>
        var AIZ = AIZ || {};
    </script>
</head>
<body>
    <div class="aiz-main-wrapper d-flex">

        <div class="flex-grow-1">
            @yield('content')
        </div>

    </div><!-- .aiz-main-wrapper -->
    <script src="{{ static_asset('assets/js/vendors.js') }}" ></script>
    <script src="{{ static_asset('assets/js/aiz-core.js') }}" ></script>

    @yield('script')

    <script type="text/javascript">
    @foreach (session('flash_notification', collect())->toArray() as $message)
        AIZ.plugins.notify('{{ $message['level'] }}', '{{ $message['message'] }}');
    @endforeach
    </script>
</body>
</html>
