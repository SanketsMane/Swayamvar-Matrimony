@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
    <div class="row align-items-center">
        <div class="col-md-6">
            <h1 class="h3">{{ translate('Fill Biodata') }}</h1>
            <p class="text-muted fs-12">{{ translate('Register a new member profile on behalf of a customer') }}</p>
        </div>
        <div class="col-md-6 text-right">
            <a href="{{ route('telecalling.dashboard') }}" class="btn btn-light">
                <i class="las la-arrow-left mr-1"></i>{{ translate('Back to Dashboard') }}
            </a>
        </div>
    </div>
</div>

@if ($errors->any())
    <div class="alert alert-danger mb-4">
        <ul class="mb-0">
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif

<div class="row">
    <div class="col-lg-9 mx-auto">
        <form action="{{ route('telecalling.store_biodata') }}" method="POST">
            @csrf

            {{-- SECTION: Personal Information --}}
            <div class="card mb-4">
                <div class="card-header">
                    <h6 class="mb-0"><i class="las la-user mr-2"></i>{{ translate('Personal Information') }}</h6>
                </div>
                <div class="card-body">
                    <div class="row gutters-10">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('First Name') }} <span class="text-danger">*</span></label>
                                <input type="text" name="first_name" class="form-control" value="{{ old('first_name') }}" placeholder="{{ translate('First Name') }}" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Last Name') }} <span class="text-danger">*</span></label>
                                <input type="text" name="last_name" class="form-control" value="{{ old('last_name') }}" placeholder="{{ translate('Last Name') }}" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Phone Number') }} <span class="text-danger">*</span></label>
                                <input type="text" name="phone" class="form-control" value="{{ old('phone') }}" placeholder="{{ translate('Mobile Number') }}" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Email Address') }}</label>
                                <input type="email" name="email" class="form-control" value="{{ old('email') }}" placeholder="{{ translate('Email (Optional)') }}">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- SECTION: Profile Details --}}
            <div class="card mb-4">
                <div class="card-header">
                    <h6 class="mb-0"><i class="las la-id-card mr-2"></i>{{ translate('Profile Details') }}</h6>
                </div>
                <div class="card-body">
                    <div class="row gutters-10">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Gender') }} <span class="text-danger">*</span></label>
                                <select class="form-control aiz-selectpicker" name="gender" required>
                                    <option value="Male" {{ old('gender') == 'Male' ? 'selected' : '' }}>Male</option>
                                    <option value="Female" {{ old('gender') == 'Female' ? 'selected' : '' }}>Female</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Date of Birth') }} <span class="text-danger">*</span></label>
                                <input type="text" class="form-control aiz-date-range"
                                    name="date_of_birth"
                                    value="{{ old('date_of_birth') }}"
                                    placeholder="Select DOB (min 18 years)"
                                    data-single="true"
                                    data-show-dropdown="true"
                                    data-max-date="{{ date('Y-m-d', strtotime('-18 years')) }}"
                                    autocomplete="off" required>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Filling On Behalf Of') }} <span class="text-danger">*</span></label>
                                <select class="form-control aiz-selectpicker" name="on_behalf" data-live-search="true" required>
                                    <option value="">{{ translate('Select') }}</option>
                                    @foreach($on_behalves as $ob)
                                        <option value="{{ $ob->id }}" {{ old('on_behalf') == $ob->id ? 'selected' : '' }}>{{ $ob->name }}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Marital Status') }} <span class="text-danger">*</span></label>
                                <select class="form-control aiz-selectpicker" name="marital_status" data-live-search="true" required>
                                    <option value="">{{ translate('Select') }}</option>
                                    @foreach($marital_statuses as $ms)
                                        <option value="{{ $ms->id }}" {{ old('marital_status') == $ms->id ? 'selected' : '' }}>{{ $ms->name }}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Mother Tongue / Language') }} <span class="text-danger">*</span></label>
                                <select class="form-control aiz-selectpicker" name="language" data-live-search="true" required>
                                    <option value="">{{ translate('Select') }}</option>
                                    @foreach($languages as $lang)
                                        <option value="{{ $lang->id }}" {{ old('language') == $lang->id ? 'selected' : '' }}>{{ $lang->name }}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- SECTION: Religious & Community --}}
            <div class="card mb-4">
                <div class="card-header">
                    <h6 class="mb-0"><i class="las la-place-of-worship mr-2"></i>{{ translate('Religious & Community Info') }}</h6>
                </div>
                <div class="card-body">
                    <div class="row gutters-10">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Religion') }}</label>
                                <select class="form-control aiz-selectpicker" name="religion" data-live-search="true" id="religion_select">
                                    <option value="">{{ translate('Nothing Selected') }}</option>
                                    @foreach($religions as $religion)
                                        <option value="{{ $religion->id }}" {{ old('religion') == $religion->id ? 'selected' : '' }}>{{ $religion->name }}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label>{{ translate('Caste') }}</label>
                                <select class="form-control aiz-selectpicker" name="caste" data-live-search="true" id="caste_select">
                                    <option value="">{{ translate('Nothing Selected') }}</option>
                                    @foreach($castes as $caste)
                                        <option value="{{ $caste->id }}" data-religion="{{ $caste->religion_id }}" {{ old('caste') == $caste->id ? 'selected' : '' }}>{{ $caste->name }}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="form-group">
                                <label>{{ translate('Sub Caste') }}</label>
                                <select class="form-control aiz-selectpicker" name="sub_caste" data-live-search="true" id="sub_caste_select">
                                    <option value="">{{ translate('Nothing Selected') }}</option>
                                    @foreach($sub_castes as $sub_caste)
                                        <option value="{{ $sub_caste->id }}" data-caste="{{ $sub_caste->caste_id }}" {{ old('sub_caste') == $sub_caste->id ? 'selected' : '' }}>{{ $sub_caste->name }}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- SECTION: Education & Career --}}
            <div class="card mb-4">
                <div class="card-header">
                    <h6 class="mb-0"><i class="las la-graduation-cap mr-2"></i>{{ translate('Education & Career') }}</h6>
                </div>
                <div class="card-body">
                    <div class="row gutters-10">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Highest Education') }}</label>
                                <input type="text" name="education" class="form-control" value="{{ old('education') }}" placeholder="{{ translate('e.g. B.Tech, MBA') }}">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Occupation') }}</label>
                                <input type="text" name="occupation" class="form-control" value="{{ old('occupation') }}" placeholder="{{ translate('e.g. Software Engineer') }}">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- SECTION: Location Details --}}
            <div class="card mb-4">
                <div class="card-header">
                    <h6 class="mb-0"><i class="las la-map-marker mr-2"></i>{{ translate('Location Details') }}</h6>
                </div>
                <div class="card-body">
                    <div class="row gutters-10">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>{{ translate('Country') }}</label>
                                <select class="form-control aiz-selectpicker" name="country" data-live-search="true" id="country_select">
                                    <option value="">{{ translate('Select') }}</option>
                                    @foreach($countries as $country)
                                        <option value="{{ $country->id }}" {{ old('country') == $country->id ? 'selected' : '' }}>{{ $country->name }}</option>
                                    @endforeach
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>{{ translate('State') }}</label>
                                <select class="form-control aiz-selectpicker" name="state" data-live-search="true" id="state_select">
                                    <option value="">{{ translate('Select Country First') }}</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label>{{ translate('City') }}</label>
                                <select class="form-control aiz-selectpicker" name="city" data-live-search="true" id="city_select">
                                    <option value="">{{ translate('Select State First') }}</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- SECTION: Physical Attributes --}}
            <div class="card mb-4">
                <div class="card-header">
                    <h6 class="mb-0"><i class="las la-ruler-vertical mr-2"></i>{{ translate('Physical Attributes') }}</h6>
                </div>
                <div class="card-body">
                    <div class="row gutters-10">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>{{ translate('Height (e.g. 5.8)') }}</label>
                                <input type="number" step="0.1" name="height" class="form-control" value="{{ old('height') }}" placeholder="{{ translate('Height') }}">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {{-- SECTION: Package Selection --}}
            <div class="card mb-4">
                <div class="card-header">
                    <h6 class="mb-0"><i class="las la-boxes mr-2"></i>{{ translate('Select Membership Package') }}</h6>
                </div>
                <div class="card-body">
                    <p class="text-muted fs-12 mb-3">{{ translate('A manual payment will be recorded automatically.') }}</p>
                    <div class="row gutters-10">
                        @foreach($packages as $pkg)
                            <div class="col-md-4 mb-3">
                                <label class="d-block mb-0" style="cursor:pointer;">
                                    <input type="radio" name="package" value="{{ $pkg->id }}" {{ $loop->first ? 'checked' : '' }} required class="d-none pkg-radio" data-id="{{ $pkg->id }}">
                                    <div class="border rounded p-3 text-center pkg-card {{ $loop->first ? 'border-primary bg-soft-primary' : '' }}" style="transition:all 0.2s;border-radius:12px!important;">
                                        <strong class="d-block fs-15 mb-1">{{ $pkg->name }}</strong>
                                        <span class="text-primary fw-600 fs-18">{{ format_price($pkg->price) }}</span>
                                        <small class="d-block text-muted mt-1">{{ $pkg->validity }} days validity</small>
                                    </div>
                                </label>
                            </div>
                        @endforeach
                    </div>
                </div>
            </div>

            {{-- Submit --}}
            <div class="text-right mb-5">
                <button type="reset" class="btn btn-light mr-2">{{ translate('Reset') }}</button>
                <button type="submit" class="btn btn-primary btn-lg px-5">
                    <i class="las la-check-circle mr-2"></i>{{ translate('Submit Biodata') }}
                </button>
            </div>
        </form>
    </div>
</div>

@endsection

@section('script')
<script>
    $(document).ready(function() {

        // Sanket: Filter caste dropdown when religion changes
        function filterCastes(religion_id) {
            $('#caste_select option').each(function() {
                if (!$(this).val()) return;
                var matches = !religion_id || $(this).data('religion') == religion_id;
                $(this).prop('disabled', !matches);
                if (!matches && $('#caste_select').val() == $(this).val()) $('#caste_select').val('');
            });
            if (typeof AIZ !== 'undefined') AIZ.plugins.bootstrapSelect('refresh');
            filterSubCastes($('#caste_select').val());
        }

        // Sanket: Filter sub-caste dropdown when caste changes
        function filterSubCastes(caste_id) {
            $('#sub_caste_select option').each(function() {
                if (!$(this).val()) return;
                var matches = !caste_id || $(this).data('caste') == caste_id;
                $(this).prop('disabled', !matches);
                if (!matches && $('#sub_caste_select').val() == $(this).val()) $('#sub_caste_select').val('');
            });
            if (typeof AIZ !== 'undefined') AIZ.plugins.bootstrapSelect('refresh');
        }

        $('#religion_select').on('change', function() {
            filterCastes($(this).val());
        });

        $('#caste_select').on('change', function() {
            filterSubCastes($(this).val());
        });

        // Sanket: AJAX for States and Cities
        $('#country_select').on('change', function() {
            var country_id = $(this).val();
            $('#state_select').html('<option value="">{{ translate('Loading states...') }}</option>');
            if (typeof AIZ !== 'undefined') AIZ.plugins.bootstrapSelect('refresh');
            
            $.post('{{ route('states.get_state_by_country') }}', { _token: '{{ csrf_token() }}', country_id: country_id }, function(data) {
                $('#state_select').html('<option value="">{{ translate('Select State') }}</option>');
                $(data).each(function(index, value) {
                    $('#state_select').append('<option value="' + value.id + '">' + value.name + '</option>');
                });
                if (typeof AIZ !== 'undefined') AIZ.plugins.bootstrapSelect('refresh');
                $('#city_select').html('<option value="">{{ translate('Select State First') }}</option>');
                if (typeof AIZ !== 'undefined') AIZ.plugins.bootstrapSelect('refresh');
            });
        });

        $('#state_select').on('change', function() {
            var state_id = $(this).val();
            $('#city_select').html('<option value="">{{ translate('Loading cities...') }}</option>');
            if (typeof AIZ !== 'undefined') AIZ.plugins.bootstrapSelect('refresh');

            $.post('{{ route('cities.get_cities_by_state') }}', { _token: '{{ csrf_token() }}', state_id: state_id }, function(data) {
                $('#city_select').html('<option value="">{{ translate('Select City') }}</option>');
                $(data).each(function(index, value) {
                    $('#city_select').append('<option value="' + value.id + '">' + value.name + '</option>');
                });
                if (typeof AIZ !== 'undefined') AIZ.plugins.bootstrapSelect('refresh');
            });
        });

        // Sanket: Visual package card selection
        $('input.pkg-radio').on('change', function() {
            $('.pkg-card').removeClass('border-primary bg-soft-primary');
            $(this).siblings('.pkg-card').addClass('border-primary bg-soft-primary');
        });

        $('label').on('click', function() {
            var radio = $(this).find('input.pkg-radio');
            if (radio.length) {
                radio.prop('checked', true);
                $('.pkg-card').removeClass('border-primary bg-soft-primary');
                radio.siblings('.pkg-card').addClass('border-primary bg-soft-primary');
            }
        });
    });
</script>
@endsection
{{-- Sanket: Fill Biodata web panel view with full matrimony profile fields --}}
