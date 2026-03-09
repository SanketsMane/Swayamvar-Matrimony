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

                <form id="import-form" action="{{ route('lead-upload.process', $upload->id) }}" method="POST">
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
                        <button type="submit" class="btn btn-primary" id="submit-btn">{{ translate('Process Import') }}</button>
                    </div>
                </form>

                <!-- Sanket: Progress Bar UI -->
                <div id="progress-container" class="d-none mt-4 text-center">
                    <div class="alert alert-info py-3">
                        <h6 class="mb-3"><i class="las la-spinner la-spin mr-2"></i>{{ translate('Processing Leads... Please do not close this window.') }}</h6>
                        <div class="progress mb-2" style="height: 25px;">
                            <div id="progress-bar" class="progress-bar progress-bar-striped progress-bar-animated bg-success" role="progressbar" style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">0%</div>
                        </div>
                        <div id="progress-text" class="text-secondary small mt-2">
                            {{ translate('Initializing...') }}
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
@endsection

@section('script')
<script type="text/javascript">
    $(document).ready(function() {
        $('#import-form').on('submit', function(e) {
            e.preventDefault();
            
            // UI Switch [Sanket]
            $('#import-form').addClass('d-none');
            $('#progress-container').removeClass('d-none');
            $('#submit-btn').prop('disabled', true);

            var formData = $(this).serialize();
            var uploadId = "{{ $upload->id }}";
            
            // Start the actual processing [Sanket]
            $.ajax({
                url: $(this).attr('action'),
                type: 'POST',
                data: formData,
                success: function(response) {
                    // Success will eventually be handled by polling or final redirect
                },
                error: function(xhr) {
                    alert('An error occurred during processing. Please check logs.');
                    location.reload();
                }
            });

            // Start Polling for Progress [Sanket]
            var pollInterval = setInterval(function() {
                $.ajax({
                    url: "{{ route('lead-upload.progress_api', $upload->id) }}",
                    type: 'GET',
                    success: function(data) {
                        var percent = data.percentage;
                        $('#progress-bar').css('width', percent + '%').attr('aria-valuenow', percent).text(percent + '%');
                        
                        var text = 'Processed ' + data.processed + ' of ' + data.total + ' rows...';
                        if(data.valid > 0) text += ' (Valid: ' + data.valid + ')';
                        $('#progress-text').text(text);

                        if (percent >= 100 || data.status == 'completed') {
                            clearInterval(pollInterval);
                            AIZ.plugins.notify('success', '{{ translate("Import Completed!") }}');
                            setTimeout(function() {
                                window.location.href = "{{ route('lead-upload.index') }}";
                            }, 2000);
                        }
                    },
                    error: function() {
                        // Keep polling silently or handle error
                    }
                });
            }, 2000);
        });
    });
</script>
@endsection
            </div>
        </div>
    </div>
</div>
@endsection
{{-- Sanket: Smart Lead Upload Column Mapping View --}}
