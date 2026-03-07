@extends('admin.layouts.app')
@section('content')

<div class="row">
    <div class="col-lg-8 mx-auto">
        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0 h6">{{ translate('Member Verification') }}</h5>
                {{-- Sanket: Status badge based on current verification_status --}}
                @if($user->verification_status == 'approved')
                    <span class="badge badge-success px-3 py-2">✓ Approved</span>
                @elseif($user->verification_status == 'rejected')
                    <span class="badge badge-danger px-3 py-2">✗ Rejected</span>
                @elseif($user->verification_status == 'query')
                    <span class="badge badge-warning px-3 py-2">? Query Sent</span>
                @elseif($user->verification_info != null)
                    <span class="badge badge-info px-3 py-2">⏳ Pending Review</span>
                @endif
            </div>
            <div class="card-body row">
                <div class="col-md-4">
                    <h6 class="mb-4">{{ translate('User Info') }}</h6>
                    <p class="text-muted">
                        <strong>{{ translate('Code') }} :</strong>
                        <span class="ml-2">{{ $user->code }}</span>
                    </p>
                    <p class="text-muted">
                        <strong>{{ translate('Name') }} :</strong>
                        <span class="ml-2">{{ $user->first_name.' '.$user->last_name }}</span>
                    </p>
                    <p class="text-muted">
                        <strong>{{translate('Email')}} :</strong>
                        <span class="ml-2">{{ $user->email }}</span>
                    </p>
                    <p class="text-muted">
                        <strong>{{translate('Phone')}} :</strong>
                        <span class="ml-2">{{ $user->phone }}</span>
                    </p>

                    {{-- Sanket: Show previous admin message if set --}}
                    @if($user->verification_rejection_reason)
                        <div class="mt-3 p-2 bg-light rounded border-left border-warning">
                            <strong class="text-warning">Previous Admin Message:</strong>
                            <p class="mb-0 mt-1 text-muted small">{{ $user->verification_rejection_reason }}</p>
                        </div>
                    @endif
                    <br>
                </div>
                <div class="col-md-8">
                    <h6 class="mb-4">{{ translate('Verification Info') }}</h6>
                    @if ($user->verification_info != null)
                        <table class="table table-striped table-bordered" cellspacing="0" width="100%">
                            <tbody>
                                @php
                                    $verification_data = json_decode($user->verification_info);
                                @endphp
                                @if(is_array($verification_data) && isset($verification_data[0]->label))
                                    {{-- Old Format --}}
                                    @foreach ($verification_data as $key => $info)
                                        <tr>
                                            <th class="text-muted">{{ $info->label }}</th>
                                            @if ($info->type == 'text' || $info->type == 'select' || $info->type == 'radio')
                                                <td> {{ $info->value }} </td>
                                            @elseif ($info->type == 'multi_select')
                                                <td> {{ @implode(', ', json_decode($info->value)) }} </td>
                                            @elseif ($info->type == 'file')
                                                <td>
                                                    <a href="{{ static_asset($info->value) }}" target="_blank" class="btn-info px-2 rounded-2">{{translate('Click here')}}</a>
                                                </td>
                                            @endif
                                        </tr>
                                    @endforeach
                                @else
                                    {{-- New 3-Step Format from Flutter --}}
                                    @if(isset($verification_data->id_type))
                                        <tr>
                                            <th class="text-muted">{{ translate('ID Type') }}</th>
                                            <td>{{ $verification_data->id_type }}</td>
                                        </tr>
                                    @endif
                                    @if(isset($verification_data->id_number))
                                        <tr>
                                            <th class="text-muted">{{ translate('ID Number') }}</th>
                                            <td>{{ $verification_data->id_number }}</td>
                                        </tr>
                                    @endif
                                    @if(isset($verification_data->id_front))
                                        <tr>
                                            <th class="text-muted">{{ translate('ID Front') }}</th>
                                            <td>
                                                <a href="{{ static_asset($verification_data->id_front) }}" target="_blank" class="btn-info px-2 rounded-2">{{translate('View Front')}}</a>
                                            </td>
                                        </tr>
                                    @endif
                                    @if(isset($verification_data->id_back))
                                        <tr>
                                            <th class="text-muted">{{ translate('ID Back') }}</th>
                                            <td>
                                                <a href="{{ static_asset($verification_data->id_back) }}" target="_blank" class="btn-info px-2 rounded-2">{{translate('View Back')}}</a>
                                            </td>
                                        </tr>
                                    @endif
                                    @if(isset($verification_data->selfie))
                                        <tr>
                                            <th class="text-muted">{{ translate('Selfie') }}</th>
                                            <td>
                                                <a href="{{ static_asset($verification_data->selfie) }}" target="_blank" class="btn-info px-2 rounded-2">{{translate('View Selfie')}}</a>
                                            </td>
                                        </tr>
                                    @endif
                                @endif
                            </tbody>
                        </table>
                    @else
                        <p class="text-muted">No verification documents submitted yet.</p>
                    @endif

                    {{-- Sanket: Admin actions — Approve / Reject / Query with message form --}}
                    @if ($user->verification_info != null && $user->verification_status != 'approved')
                        <div class="mt-4 p-3 bg-light rounded">
                            <h6 class="mb-3 text-dark">Admin Action</h6>
                            <div class="form-group mb-3">
                                <label for="admin_message" class="font-weight-bold">Message to Member <span class="text-muted small">(optional — shown for Reject & Query)</span></label>
                                <textarea id="admin_message" class="form-control" rows="3" placeholder="e.g. Your ID image is blurry. Please re-upload a clear photo."></textarea>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="{{ route('member.approve_verification', $user->id) }}" 
                                   onclick="return confirm('{{ translate('Are you sure to approve this verification?') }}')"
                                   class="btn btn-sm btn-success mr-2">
                                    ✓ {{ translate('Approve') }}
                                </a>
                                <button type="button" onclick="submitVerificationAction('{{ route('member.reject_verification', $user->id) }}')" 
                                        class="btn btn-sm btn-danger mr-2">
                                    ✗ {{ translate('Reject') }}
                                </button>
                                <button type="button" onclick="submitVerificationAction('{{ route('member.query_verification', $user->id) }}')" 
                                        class="btn btn-sm btn-warning">
                                    ? {{ translate('Ask Query') }}
                                </button>
                            </div>
                        </div>
                    @endif
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@section('script')
<script>
    // Sanket: Submits reject/query form with the optional admin message
    function submitVerificationAction(url) {
        const message = document.getElementById('admin_message').value;
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = url;

        const csrf = document.createElement('input');
        csrf.type = 'hidden';
        csrf.name = '_token';
        csrf.value = '{{ csrf_token() }}';
        form.appendChild(csrf);

        const msg = document.createElement('input');
        msg.type = 'hidden';
        msg.name = 'admin_message';
        msg.value = message;
        form.appendChild(msg);

        document.body.appendChild(form);
        form.submit();
    }
</script>
@endsection