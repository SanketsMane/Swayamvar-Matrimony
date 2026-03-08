@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
	<div class="row align-items-center">
		<div class="col-md-6">
			<h1 class="h3">{{translate('Telecalling Admin Analytics')}}</h1>
		</div>
	</div>
</div>

<div class="row gutters-10">
    <div class="col-md-3">
        <div class="card bg-grad-1 text-white overflow-hidden shadow-none mb-3">
            <div class="card-body">
                <div class="opacity-50">
                    <span class="fs-12 d-block">{{ translate('Total') }}</span>
                    {{ translate('Active Leads') }}
                </div>
                <div class="h3 fw-700 mb-3">{{ $data['total_leads'] }}</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-grad-2 text-white overflow-hidden shadow-none mb-3">
            <div class="card-body">
                <div class="opacity-50">
                    <span class="fs-12 d-block">{{ translate('Total') }}</span>
                    {{ translate('Inactive Leads') }}
                </div>
                <div class="h3 fw-700 mb-3">{{ $data['total_inactive'] }}</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-grad-3 text-white overflow-hidden shadow-none mb-3">
            <div class="card-body">
                <div class="opacity-50">
                    <span class="fs-12 d-block">{{ translate('Registered') }}</span>
                    {{ translate('Telecallers') }}
                </div>
                <div class="h3 fw-700 mb-3">{{ $data['total_telecallers'] }}</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-grad-4 text-white overflow-hidden shadow-none mb-3">
            <div class="card-body">
                <div class="opacity-50">
                    <span class="fs-12 d-block">{{ translate('Calls Done') }}</span>
                    {{ translate('Today') }}
                </div>
                <div class="h3 fw-700 mb-3">{{ $data['total_calls_today'] }}</div>
            </div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="card bg-dark text-white overflow-hidden shadow-none mb-3">
            <div class="card-body">
                <div class="opacity-50">
                    <span class="fs-12 d-block">{{ translate('Biodatas') }}</span>
                    {{ translate('Entries') }}
                </div>
                <div class="h3 fw-700 mb-3">{{ $data['total_biodatas'] }}</div>
            </div>
        </div>
    </div>
</div>

<div class="row gutters-10">
    <div class="col-md-8">
        <div class="card shadow-sm border-0">
            <div class="card-header border-0 bg-white py-3">
                <h6 class="mb-0 fw-700 text-primary">{{ translate('Top Performing Sales Executives') }}</h6>
            </div>
            <div class="card-body pt-0">
                <table class="table aiz-table mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>{{translate('Executive Name')}}</th>
                            <th>{{translate('Biodatas Filled')}}</th>
                            <th>{{translate('Status')}}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($data['top_executives'] as $key => $executive)
                            <tr>
                                <td>
                                    @if($key == 0) <span class="badge badge-inline badge-warning">1st</span>
                                    @elseif($key == 1) <span class="badge badge-inline badge-secondary">2nd</span>
                                    @elseif($key == 2) <span class="badge badge-inline badge-soft-warning text-dark">3rd</span>
                                    @else {{ $key + 1 }} @endif
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="user-avatar-sm bg-soft-primary mr-3 rounded-circle d-flex align-items-center justify-content-center"
                                            style="width:32px;height:32px;font-weight:bold;color:#3874ff;">
                                            {{ strtoupper(substr($executive->first_name, 0, 1)) }}
                                        </div>
                                        <span class="fw-600">{{ $executive->first_name }} {{ $executive->last_name }}</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge badge-inline badge-soft-success p-2 px-3" style="font-size: 14px;">
                                        {{ $executive->biodatas_count }}
                                    </span>
                                </td>
                                <td>
                                    @if($executive->approved)
                                        <span class="badge badge-dot badge-success mr-1"></span>{{translate('Active')}}
                                    @else
                                        <span class="badge badge-dot badge-danger mr-1"></span>{{translate('Inactive')}}
                                    @endif
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card">
            <div class="card-header">
                <h6 class="mb-0 fs-14">{{ translate('Recent Actions') }}</h6>
            </div>
            <div class="card-body">
                <ul class="list-group list-group-flush">
                    @php
                        $recent_logs = \App\Models\TelecallingCallLog::latest()->limit(5)->get();
                    @endphp
                    @foreach($recent_logs as $log)
                        <li class="list-group-item px-0">
                            <div class="d-flex justify-content-between">
                                <span class="fw-600">{{$log->lead->name ?? translate('Unknown Lead')}}</span>
                                <small class="text-muted">{{$log->created_at->diffForHumans()}}</small>
                            </div>
                            <div class="small">
                                {{translate('Status')}}: <span class="badge badge-inline badge-info">{{$log->status}}</span>
                                <br>
                                {{translate('by')}} {{$log->agent->first_name ?? ''}}
                            </div>
                        </li>
                    @endforeach
                </ul>
            </div>
        </div>
    </div>
</div>

@endsection
