@extends('frontend.layouts.app')
@section('content')

    <!-- Jeevansathi Hero Section -->
    <section class="jeevansathi-hero-section" style="background-image: url('{{ static_asset('assets/img/custom/Gemini_Generated_Image_9fk3p79fk3p79fk3.png') }}'); min-height: 500px;">
        <div class="jeevansathi-hero-overlay"></div>
        
        <div class="container jeevansathi-hero-content text-center text-lg-left">
            <div class="row align-items-center">
                <!-- Content: Emotional Messaging -->
                <div class="col-lg-8 col-xl-7">
                    <h1 class="hero-headline-js">
                        {{ translate('Now, chat for free!') }}
                    </h1>
                    <p class="hero-subtext-js">
                        {{ translate('Finding your perfect match just became easier') }}
                    </p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Overlapping Registration Form -->
    <section class="container hero-overlapping-form-wrapper">
        <div class="hero-overlapping-form">
            <h3 class="fw-600 mb-3 fs-18 text-dark">{{ translate('Create Profile For') }}</h3>
            <form action="{{ route('register') }}" method="GET">
                <div class="row align-items-end">
                    <div class="col-lg-3 mb-3 mb-lg-0">
                        <label class="d-block fw-700 text-uppercase mb-1" style="font-size: 11px; color: #555;">{{ translate('Select') }}</label>
                        <select name="on_behalf" class="form-control bg-light border-1 h-45px">
                            <option value="">{{ translate('Select Profile') }}</option>
                            @foreach (\App\Models\OnBehalf::all() as $on_behalf)
                                <option value="{{ $on_behalf->id }}">{{ $on_behalf->name }}</option>
                            @endforeach
                        </select>
                    </div>

                    <div class="col-lg-3 mb-3 mb-lg-0">
                        <label class="d-block fw-700 text-uppercase mb-1" style="font-size: 11px; color: #555;">{{ translate('Email Address') }}</label>
                        <input type="email" name="email" class="form-control bg-light border-1 h-45px" placeholder="{{ translate('someone@example.com') }}">
                    </div>

                    <div class="col-lg-3 mb-3 mb-lg-0">
                        <label class="d-block fw-700 text-uppercase mb-1" style="font-size: 11px; color: #555;">{{ translate('Mobile No.') }}</label>
                        <div class="input-group h-45px">
                            <div class="input-group-prepend">
                                <span class="input-group-text bg-light border-1 px-2">+91</span>
                            </div>
                            <input type="text" name="phone" class="form-control bg-light border-1 border-left-0 h-45px" placeholder="">
                        </div>
                    </div>

                    <div class="col-lg-3">
                        <button type="submit" class="btn-js-register w-100 m-0 h-45px" style="padding: 0; line-height: 45px;">
                            {{ translate('Register for Free') }}
                        </button>
                    </div>
                </div>

                <div class="row mt-3">
                    <div class="col-12 text-center text-lg-left">
                        <p class="m-0" style="font-size: 11px; color: #777;">
                            {{ translate("By clicking on 'Register Free', you confirm that you accept the") }} 
                            <a href="{{ env('APP_URL') }}/terms" style="color: #d9475c; font-weight: 500;">{{ translate('Terms of Use') }}</a> {{ translate('and') }} 
                            <a href="{{ env('APP_URL') }}/privacy-policy" style="color: #d9475c; font-weight: 500;">{{ translate('Privacy Policy') }}</a>
                        </p>
                    </div>
                </div>
            </form>
        </div>
    </section>

    <!-- Bringing People Together Section -->
    <section class="bringing-people-section" style="padding-top: 50px; padding-bottom: 60px;">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 d-flex align-items-center mb-4 mb-lg-0">
                    <div class="bpt-title-wrap">
                        <div class="bpt-subtitle">{{ translate('MORE THAN 25 YEARS OF') }}</div>
                        <h2 class="bpt-title">{{ translate('Bringing People') }} <span>{{ translate('Together') }}</span></h2>
                    </div>
                </div>
                
                <div class="col-lg-8">
                    <div class="row text-center text-lg-left">
                        <div class="col-md-4 mb-4 mb-md-0">
                            <div class="bpt-feature-icon">
                                <i class="las la-users"></i>
                            </div>
                            <h4 class="bpt-feature-title">{{ translate('100% Screened Profiles') }}</h4>
                            <p class="bpt-feature-desc">{{ translate('Search by location, community, profession & more from lakhs of active profiles') }}</p>
                        </div>
                        <div class="col-md-4 mb-4 mb-md-0">
                            <div class="bpt-feature-icon">
                                <i class="las la-shield-alt"></i>
                            </div>
                            <h4 class="bpt-feature-title">{{ translate('Verifications by Personal Visit') }}</h4>
                            <p class="bpt-feature-desc">{{ translate('Special listing for profiles verified by our agents through personal visits') }}</p>
                        </div>
                        <div class="col-md-4">
                            <div class="bpt-feature-icon">
                                <i class="las la-lock"></i>
                            </div>
                            <h4 class="bpt-feature-title">{{ translate('Control over Privacy') }}</h4>
                            <p class="bpt-feature-desc">{{ translate('Restrict unwanted access to contact details & photos/videos') }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!-- End Hero & Bringing People Together -->
    <!-- End Hero -->





    <!-- Localized Banner Section Redesigned -->
    <section class="py-5 bg-white">
        <div class="container">
            <div class="row gutters-20">
                <div class="col-xl-4 col-md-6 mb-4">
                    <a href="{{ route('member.listing') }}" class="marathi-banner-card">
                        <img src="{{ static_asset('assets/img/custom/bride_banner.png') }}" class="banner-img" alt="{{ translate('Find Marathi Bride') }}">
                    </a>
                </div>
                <div class="col-xl-4 col-md-6 mb-4">
                    <a href="{{ route('member.listing') }}" class="marathi-banner-card">
                        <img src="{{ static_asset('assets/img/custom/ritual_banner.png') }}" class="banner-img" alt="{{ translate('Marathi Traditions') }}">
                    </a>
                </div>
                <div class="col-xl-4 col-md-6 mb-4 d-md-none d-xl-block">
                    <a href="{{ route('member.listing') }}" class="marathi-banner-card">
                        <img src="{{ static_asset('assets/img/custom/groom_banner.png') }}" class="banner-img" alt="{{ translate('Find Marathi Groom') }}">
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    @if (get_setting('show_how_it_works_section') == 'on' && get_setting('how_it_works_steps_titles') != null)
        <section class="py-7 bg-white border-top border-bottom">
            <div class="container">
                <div class="row text-center mb-5">
                    <div class="col-12">
                        <h2 class="fs-24 fw-700 text-dark">{{ translate(get_setting('how_it_works_title')) }}</h2>
                        <p class="fs-15 text-muted mb-0">{{ translate(get_setting('how_it_works_sub_title')) }}</p>
                    </div>
                </div>
                <div class="row gutters-20">
                    @php
                        $how_it_works_steps_titles = json_decode(get_setting('how_it_works_steps_titles'));
                        $step = 1;
                    @endphp
                    @foreach ($how_it_works_steps_titles as $key => $how_it_works_steps_title)
                        <div class="col-lg-4 text-center mb-4">
                            <div class="p-3">
                                <img src="{{ uploaded_asset(json_decode(get_setting('how_it_works_steps_icons'), true)[$key]) }}" class="h-60px mb-3">
                                <h3 class="fs-18 fw-600 text-dark">{{ translate($how_it_works_steps_title) }}</h3>
                                <p class="fs-14 text-muted">
                                    {{ translate(json_decode(get_setting('how_it_works_steps_sub_titles'), true)[$key]) }}
                                </p>
                            </div>
                        </div>
                    @endforeach
                </div>
            </div>
        </section>
    @endif

    <!-- Ambassador Section Refined Redesign (Organized Layout + Original Text) -->
    <section class="py-0 bg-white overflow-hidden position-relative mb-4">
        <div class="container-fluid px-0">
            <div class="position-relative">
                <img src="{{ static_asset('assets/img/custom/actor_banner.png') }}" class="img-fluid w-100" alt="{{ translate('Swayamvar Ambassador') }}">
                
                <!-- Premium Ambassador Text Overlays -->
                <div class="position-absolute absolute-full d-flex align-items-center ambassador-text-overlay">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-5 offset-lg-7">
                                <!-- Top Badge (Restored Original Text) -->
                                <div class="ambassador-badge">
                                    <h3 class="text-white mb-0" style="font-weight: 800; letter-spacing: 1px; display: flex; align-items: center;">
                                        <i class="la la-certificate mr-2" style="font-size: 36px; color: #d48344;"></i>
                                        <span>{{ translate('Trusted by Millions') }}</span>
                                    </h3>
                                    <p class="mt-1">{{ translate('Serving Families Since 1999') }}</p>
                                </div>

                                <!-- Main Title (Restored Original Text) -->
                                <h1 class="ambassador-title">
                                    {{ translate('Swayamvar Matrimony') }}
                                </h1>
                                <p class="ambassador-subtitle">
                                    {{ translate('The Premier Destination for Finding Your Perfect Life Partner') }}
                                </p>

                                <!-- Features with Icons (Restored Original Text) -->
                                <div class="ambassador-feature-list mb-5">
                                    <div class="ambassador-feature-unit">
                                        <div class="ambassador-icon-circle">
                                            <i class="la la-star"></i>
                                        </div>
                                        <div class="ambassador-feature-info">
                                            <h4>{{ translate('A Legacy of Beautiful Unions') }}</h4>
                                            <p>{{ translate('Over 25 Years of Excellence in Matchmaking') }}</p>
                                        </div>
                                    </div>

                                    <div class="ambassador-feature-unit">
                                        <div class="ambassador-icon-circle">
                                            <i class="la la-heart"></i>
                                        </div>
                                        <div class="ambassador-feature-info">
                                            <h4>{{ translate('Personalized Matchmaking') }}</h4>
                                            <p>{{ translate('Our expert consultants provide a human touch, hand-picking profiles that align with your values and lifestyle.') }}</p>
                                        </div>
                                    </div>

                                    <div class="ambassador-feature-unit">
                                        <div class="ambassador-icon-circle">
                                            <i class="la la-lock"></i>
                                        </div>
                                        <div class="ambassador-feature-info">
                                            <h4>{{ translate('Total Privacy Guaranteed') }}</h4>
                                            <p>{{ translate('We prioritize your discretion with secure, verified profiles and end-to-end confidentiality.') }}</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- CTA Button -->
                                <a href="{{ route('member.listing') }}" class="ambassador-pill-btn">
                                    {{ translate('Register Now') }} <i class="la la-arrow-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>



    <!-- Happy Story Section -->
    @if (get_setting('show_happy_story_section') == 'on')
        <section class="py-7 bg-white border-top">
            <div class="container">
                <div class="row mb-5 text-center">
                    <div class="col-12">
                        <h2 class="fs-24 fw-700 text-dark mb-2">{{ translate('Millions of Happy Marriages') }}</h2>
                        <p class="fs-15 text-muted">{{ translate('A sneak peek into our successful matches') }}</p>
                    </div>
                </div>
                <div class="row mb-4">
                    @php
                        $happy_stories = \App\Models\HappyStory::where('approved', '1')
                            ->latest()
                            ->limit(get_setting('max_happy_story_show_homepage'))
                            ->get();
                    @endphp
                    @foreach ($happy_stories as $key => $happy_story)
                        @php
                            $photo = explode(',', $happy_story->photos);
                        @endphp
                        <div class="col-lg-4 col-md-6 mb-4">
                            <a href="{{ route('story_details', $happy_story->id) }}" class="text-reset d-block border rounded bg-white shadow-sm overflow-hidden text-center h-100">
                                <img src="{{ uploaded_asset($photo[0]) }}" class="img-fluid w-100 object-fit-cover" style="height: 200px;">
                                <div class="p-3">
                                    <h3 class="fs-16 fw-600 text-dark mb-1">
                                        {{ translate($happy_story->user->first_name) . ' & ' . translate($happy_story->partner_name) }}
                                    </h3>
                                    <p class="fs-13 text-muted mb-2 text-truncate-2">{{ translate($happy_story->title) }}</p>
                                </div>
                            </a>
                        </div>
                    @endforeach
                </div>
                <div class="text-center">
                    <a href="{{ route('happy_stories') }}" class="btn-marathi-outline">{{ translate('View more stories') }}</a>
                </div>
            </div>
        </section>
    @endif

    @if (get_setting('show_homapege_package_section') == 'on')
        <section class="py-7 bg-light border-top">
            <div class="container">
                <div class="row mb-5 text-center">
                    <div class="col-12">
                        <h2 class="fs-24 fw-700 text-dark mb-2">{{ translate(get_setting('homepage_package_section_title')) }}</h2>
                        <p class="fs-15 text-muted mb-0">{{ translate(get_setting('homepage_package_section_sub_title')) }}</p>
                    </div>
                </div>
                <div class="row justify-content-center">
                    @php
                        $packages = \App\Models\Package::where('active', '1')->get();
                        $show_images = true;
                        foreach ($packages as $p) {
                            if (!$p->image) {
                                $show_images = false;
                                break;
                            }
                        }
                    @endphp
                    @foreach ($packages as $key => $package)
                        <div class="col-lg-3 col-md-6 mb-4">
                            <div class="card border border-light shadow-sm text-center h-100 rounded-0">
                                <div class="card-body p-4 d-flex flex-column">
                                    @if($show_images)
                                        <img class="mx-auto mb-3 h-60px" src="{{ uploaded_asset($package->image) }}" alt="{{ $package->name }}">
                                    @endif
                                    <h5 class="fs-18 fw-600 text-dark mb-2">{{ translate($package->name) }}</h5>
                                    <div class="mb-4">
                                        @if ($package->id == 1)
                                            <span class="fs-24 fw-700 text-dark mb-0">{{ translate('Free') }}</span>
                                        @else
                                            <span class="fs-24 fw-700 text-primary mb-0">{{ single_price($package->price) }}</span>
                                        @endif
                                        <div class="fs-12 text-muted mt-1">{{ translate($package->validity) }} {{ translate('Days') }}</div>
                                    </div>
                                    
                                    <ul class="list-unstyled fs-13 mb-4 flex-grow-1 text-left px-3">
                                        <li class="mb-2 border-bottom pb-2">
                                            <strong class="text-dark">{{ $package->express_interest }}</strong> <span class="text-muted">{{ translate('Express Interests') }}</span>
                                        </li>
                                        <li class="mb-2 border-bottom pb-2">
                                            <strong class="text-dark">{{ $package->photo_gallery }}</strong> <span class="text-muted">{{ translate('Gallery Photo') }}</span>
                                        </li>
                                        <li class="mb-2 border-bottom pb-2">
                                            <strong class="text-dark">{{ $package->contact }}</strong> <span class="text-muted">{{ translate('Contact Infos') }}</span>
                                        </li>
                                        <li class="mb-2">
                                            <span class="text-muted">{{ translate('Auto Profile Match') }} :</span>
                                            @if ($package->auto_profile_match == 0)
                                                <i class="las la-times text-danger"></i>
                                            @else
                                                <i class="las la-check text-success"></i>
                                            @endif
                                        </li>
                                    </ul>
                                    <div class="mt-auto">
                                        @if ($package->id != 1)
                                            @if (Auth::check())
                                                <a href="{{ route('package_payment_methods', encrypt($package->id)) }}"
                                                    class="btn-marathi w-100">{{ translate('Purchase') }}</a>
                                            @else
                                                <button type="button" onclick="loginModal()"
                                                    class="btn-marathi w-100">{{ translate('Purchase') }}</button>
                                            @endif
                                        @else
                                            <button disabled class="btn btn-secondary w-100 bg-secondary border-secondary fs-14 fw-600 text-white rounded-0">{{ translate('Current package') }}</button>
                                        @endif
                                    </div>
                                </div>
                            </div>
                        </div>
                    @endforeach
                </div>
            </div>
        </section>
    @endif
    
    @if (get_setting('show_homepage_review_section') == 'on')
        @php
            $testimonials = [
                ['text' => translate("Swayamvar Matrimony revolutionized my search for a life partner. Finding a compatible partner in our community was so easy with their filters!"), 'image' => "https://randomuser.me/api/portraits/women/11.jpg", 'name' => translate("Priyanka Deshmukh"), 'role' => translate("Happy Bride")],
                ['text' => translate("Finding my match on this platform was smooth and quick. The verified profiles and Marathi-focused search make it very trustworthy."), 'image' => "https://randomuser.me/api/portraits/men/12.jpg", 'name' => translate("Rahul Kulkarni"), 'role' => translate("Happy Groom")],
                ['text' => translate("The support team is exceptional, guiding us through setup. As a professional from Kolhapur, I found very relevant matches here."), 'image' => "https://randomuser.me/api/portraits/women/13.jpg", 'name' => translate("Snehal Patil"), 'role' => translate("Premium Member")],
                ['text' => translate("This platform's seamless integration enhanced our search. Found my Sahacharini within 3 months of joining. Best for Maharashtrians!"), 'image' => "https://randomuser.me/api/portraits/men/14.jpg", 'name' => translate("Amit Shinde"), 'role' => translate("Verified User")],
                ['text' => translate("Its robust features and Marathi traditions-aware customer care have transformed our search journey. Very reliable platform."), 'image' => "https://randomuser.me/api/portraits/women/15.jpg", 'name' => translate("Anjali Joshi"), 'role' => translate("Active Member")],
                ['text' => translate("The smooth implementation exceeded expectations. Searching for a bride with good cultural values was made simple. Thank you Swayamvar!"), 'image' => "https://randomuser.me/api/portraits/women/16.jpg", 'name' => translate("Sayali Gokhale"), 'role' => translate("Successful Match")],
                ['text' => translate("Our experience improved with a user-friendly design. Found my partner from Mumbai easily. Jai Maharashtra!"), 'image' => "https://randomuser.me/api/portraits/men/17.jpg", 'name' => translate("Swapnil More"), 'role' => translate("Happy Groom")],
                ['text' => translate("They delivered a solution that exceeded expectations. The match suggestions were very relevant to my family background and expectations."), 'image' => "https://randomuser.me/api/portraits/women/18.jpg", 'name' => translate("Megha Pawar"), 'role' => translate("Happy Bride")],
                ['text' => translate("Using this platform, my search for a soulmate significantly improved. Authenticity of profiles is what I liked the most."), 'image' => "https://randomuser.me/api/portraits/men/19.jpg", 'name' => translate("Sachin Thorat"), 'role' => translate("Active Member")],
            ];
            
            $col1 = array_slice($testimonials, 0, 3);
            $col2 = array_slice($testimonials, 3, 3);
            $col3 = array_slice($testimonials, 6, 3);
        @endphp

        <section class="py-7 bg-white position-relative my-5 overflow-hidden">
            <div class="container z-1 position-relative mx-auto">
                <div class="d-flex flex-column align-items-center justify-content-center mx-auto text-center" style="max-width: 540px;">
                    <div class="d-flex justify-content-center mb-3">
                        <div class="border py-1 px-4 text-dark" style="border-radius: 0.5rem !important; font-size: 14px; font-weight: 600;">{{ translate('Testimonials') }}</div>
                    </div>
                    <h2 class="fs-40 fw-700 text-dark mt-2 mb-3" style="letter-spacing: -2px;">
                        {{ translate('What our users say') }}
                    </h2>
                    <p class="text-center text-muted fs-16 opacity-75">
                        {{ translate('See what our customers have to say about us.') }}
                    </p>
                </div>

                <div class="d-flex justify-content-center mt-5 testimonial-mask" style="gap: 1.5rem;">
                    <!-- Column 1 -->
                    @if(count($col1) > 0)
                    <div class="marquee-col dur-15">
                        @for($j = 0; $j < 2; $j++)
                            @foreach($col1 as $t)
                            <div class="testimonial-card-ui">
                                <div class="text-dark fs-14 mb-4" style="line-height: 1.6;">"{{ $t['text'] }}"</div>
                                <div class="d-flex align-items-center mt-auto" style="gap: 0.75rem;">
                                    <img src="{{ $t['image'] }}" alt="{{ $t['name'] }}" class="rounded-circle" style="width: 40px; height: 40px; object-fit: cover;">
                                    <div class="d-flex flex-column text-left">
                                        <div class="name-text text-dark">{{ $t['name'] }}</div>
                                        <div class="role-text text-muted">{{ $t['role'] }}</div>
                                    </div>
                                </div>
                            </div>
                            @endforeach
                        @endfor
                    </div>
                    @endif

                    <!-- Column 2 (Hidden on mobile) -->
                    @if(count($col2) > 0)
                    <div class="marquee-col dur-19 d-none d-md-flex">
                        @for($j = 0; $j < 2; $j++)
                            @foreach($col2 as $t)
                            <div class="testimonial-card-ui">
                                <div class="text-dark fs-14 mb-4" style="line-height: 1.6;">"{{ $t['text'] }}"</div>
                                <div class="d-flex align-items-center mt-auto" style="gap: 0.75rem;">
                                    <img src="{{ $t['image'] }}" alt="{{ $t['name'] }}" class="rounded-circle" style="width: 40px; height: 40px; object-fit: cover;">
                                    <div class="d-flex flex-column text-left">
                                        <div class="name-text text-dark">{{ $t['name'] }}</div>
                                        <div class="role-text text-muted">{{ $t['role'] }}</div>
                                    </div>
                                </div>
                            </div>
                            @endforeach
                        @endfor
                    </div>
                    @endif

                    <!-- Column 3 (Hidden on mobile and tablet) -->
                    @if(count($col3) > 0)
                    <div class="marquee-col dur-17 d-none d-lg-flex">
                        @for($j = 0; $j < 2; $j++)
                            @foreach($col3 as $t)
                            <div class="testimonial-card-ui">
                                <div class="text-dark fs-14 mb-4" style="line-height: 1.6;">"{{ $t['text'] }}"</div>
                                <div class="d-flex align-items-center mt-auto" style="gap: 0.75rem;">
                                    <img src="{{ $t['image'] }}" alt="{{ $t['name'] }}" class="rounded-circle" style="width: 40px; height: 40px; object-fit: cover;">
                                    <div class="d-flex flex-column text-left">
                                        <div class="name-text text-dark">{{ $t['name'] }}</div>
                                        <div class="role-text text-muted">{{ $t['role'] }}</div>
                                    </div>
                                </div>
                            </div>
                            @endforeach
                        @endfor
                    </div>
                    @endif
                </div>
            </div>
        </section>
    @endif

    @if (get_setting('show_blog_section') == 'on')
        <section class="py-7 bg-light border-top">
            <div class="container">
                <div class="row mb-5 text-center">
                    <div class="col-12">
                        <h2 class="fs-24 fw-700 text-dark">{{ translate(get_setting('blog_section_title')) }}</h2>
                    </div>
                </div>
                <div class="row gutters-20">
                    @php
                        $blogs = \App\Models\Blog::query()
                            ->where('status', 1)
                            ->latest()
                            ->limit(3)
                            ->get();
                    @endphp
                    @foreach ($blogs as $key => $blog)
                        <div class="col-lg-4 col-md-6 mb-4">
                            <article class="card h-100 border rounded-0 shadow-sm">
                                <a href="{{ route('blog.details', $blog->slug) }}" class="d-block overflow-hidden" style="height: 200px;">
                                    <img src="{{ uploaded_asset($blog->banner) }}" alt="{{ $blog->title }}" class="img-fluid w-100 h-100 object-fit-cover">
                                </a>
                                <div class="card-body p-3">
                                    <div class="fs-12 text-muted mb-2">
                                        <i class="las la-calendar mr-1"></i> {{ date('M d, Y', strtotime($blog->created_at)) }}
                                    </div>
                                    <h3 class="fs-15 fw-600 text-dark mb-2">
                                        <a href="{{ route('blog.details', $blog->slug) }}" class="text-reset hover-text-primary">
                                            {{ translate($blog->title) }}
                                        </a>
                                    </h3>
                                    <p class="fs-13 text-muted text-truncate-2 mb-0">{{ translate($blog->short_description) }}</p>
                                </div>
                            </article>
                        </div>
                    @endforeach
                </div>
                <div class="text-center mt-3">
                    <a href="{{ route('blog') }}" class="btn-marathi-outline">{{ translate('View All Posts') }}</a>
                </div>
            </div>
        </section>
    @endif

@endsection

@section('modal')
    @include('modals.login_modal')
    @include('modals.package_update_alert_modal')
@endsection

@section('script')
    <script type="text/javascript">
        function loginModal() {
            $('#LoginModal').modal();
        }

        function package_update_alert() {
            $('.package_update_alert_modal').modal('show');
        }
    </script>
    @if(get_setting('google_recaptcha_activation') == 1)
        @include('partials.recaptcha')
    @endif
    @if(addon_activation('otp_system'))
        @include('partials.emailOrPhone')
    @endif
@endsection
