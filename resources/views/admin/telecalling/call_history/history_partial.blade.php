@forelse($logs as $log)
    <div class="border-bottom p-2 mb-2">
        <div class="d-flex justify-content-between">
            <span class="badge badge-inline badge-info">{{$log->call_status}}</span>
            <small class="text-muted">{{$log->call_datetime->format('Y-m-d H:i')}}</small>
        </div>
        <div class="mt-1">
            <strong>{{translate('Agent')}}:</strong> {{$log->agent->first_name ?? ''}}
        </div>
        <div class="text-muted small mt-1">
            {{$log->notes}}
        </div>
        @if($log->duration)
            <div class="small">
                <strong>{{translate('Duration')}}:</strong> {{$log->duration}}s
            </div>
        @endif
    </div>
@empty
    <div class="text-center p-3 text-muted">
        {{translate('No history found')}}
    </div>
@endforelse
