@extends('admin.layouts.app')

@section('content')
<div class="row">
    <div class="col-lg-8 mx-auto">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{ translate('Map Columns for') }} {{ $campaign->name }}</h5>
            </div>
            <div class="card-body">
                <p class="text-muted">{{ translate('Please map the columns from your uploaded file to the required system fields.') }}</p>
                <div class="alert alert-info">
                    <strong>{{ translate('File:') }}</strong> {{ $upload->file_name }} <br>
                    <strong>{{ translate('Campaign:') }}</strong> {{ $campaign->name }}
                </div>

                <form action="{{ route('lead-upload.process', $upload->id) }}" method="POST">
                    @csrf
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>{{ translate('System Field') }}</th>
                                <th>{{ translate('Matches Your Excel Column') }}</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach($dbFields as $key => $label)
                                <tr>
                                    <td>
                                        {{ $label }}
                                        @if($key == 'mobile')
                                            <span class="text-danger">*</span>
                                        @endif
                                    </td>
                                    <td>
                                        <select name="mapping[{{ $key }}]" class="form-control aiz-selectpicker" data-live-search="true" {{ $key == 'mobile' ? 'required' : '' }}>
                                            <option value="">{{ translate('Ignore / Do not map') }}</option>
                                            @foreach($headers as $index => $header)
                                                {{-- Try to auto-select if names match roughly --}}
                                                @php
                                                    $selected = '';
                                                    $headerLower = strtolower($header);
                                                    if ($key == 'mobile' && (strpos($headerLower, 'mobile') !== false || strpos($headerLower, 'phone') !== false || strpos($headerLower, 'contact') !== false)) $selected = 'selected';
                                                    if ($key == 'name' && (strpos($headerLower, 'name') !== false)) $selected = 'selected';
                                                    if ($key == 'email' && (strpos($headerLower, 'email') !== false)) $selected = 'selected';
                                                    if ($key == 'city' && (strpos($headerLower, 'city') !== false || strpos($headerLower, 'location') !== false)) $selected = 'selected';
                                                    if ($key == 'pincode' && (strpos($headerLower, 'pin') !== false || strpos($headerLower, 'zip') !== false)) $selected = 'selected';
                                                    if ($key == 'source' && (strpos($headerLower, 'source') !== false)) $selected = 'selected';
                                                    if ($key == 'business_type' && (strpos($headerLower, 'business') !== false || strpos($headerLower, 'type') !== false)) $selected = 'selected';
                                                @endphp
                                                <option value="{{ $index }}" {{ $selected }}>{{ $header }}</option>
                                            @endforeach
                                        </select>
                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>

                    <div class="form-group mb-0 text-right mt-4">
                        <a href="{{ route('lead-upload.index') }}" class="btn btn-light mr-2">{{ translate('Cancel') }}</a>
                        <button type="submit" class="btn btn-primary">{{ translate('Process Import') }}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection
{{-- Sanket: Smart Lead Upload Column Mapping View --}}
