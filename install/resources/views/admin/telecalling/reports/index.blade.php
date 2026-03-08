@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
	<div class="row align-items-center">
		<div class="col-md-6">
			<h1 class="h3">{{translate('Reports & Analytics')}}</h1>
		</div>
	</div>
</div>

<div class="row gutters-10">
    <div class="col-lg-3 col-md-6">
        <div class="card shadow-sm border-0">
            <div class="card-body p-3">
                <div class="d-flex align-items-center">
                    <div class="bg-soft-primary p-2 mr-3 rounded">
                        <i class="las la-user-plus text-primary fs-24"></i>
                    </div>
                    <div>
                        <span class="d-block text-muted fs-12">{{ translate('Biodatas Today') }}</span>
                        <span class="d-block fs-18 fw-700">{{ $data['biodatas_today'] }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="card shadow-sm border-0">
            <div class="card-body p-3">
                <div class="d-flex align-items-center">
                    <div class="bg-soft-success p-2 mr-3 rounded">
                        <i class="las la-calendar-week text-success fs-24"></i>
                    </div>
                    <div>
                        <span class="d-block text-muted fs-12">{{ translate('This Week') }}</span>
                        <span class="d-block fs-18 fw-700">{{ $data['biodatas_this_week'] }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="card shadow-sm border-0">
            <div class="card-body p-3">
                <div class="d-flex align-items-center">
                    <div class="bg-soft-info p-2 mr-3 rounded">
                        <i class="las la-calendar text-info fs-24"></i>
                    </div>
                    <div>
                        <span class="d-block text-muted fs-12">{{ translate('This Month') }}</span>
                        <span class="d-block fs-18 fw-700">{{ $data['biodatas_this_month'] }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-lg-3 col-md-6">
        <div class="card shadow-sm border-0">
            <div class="card-body p-3">
                <div class="d-flex align-items-center">
                    <div class="bg-soft-warning p-2 mr-3 rounded">
                        <i class="las la-users text-warning fs-24"></i>
                    </div>
                    <div>
                        <span class="d-block text-muted fs-12">{{ translate('Total Biodatas') }}</span>
                        <span class="d-block fs-18 fw-700">{{ $data['total_biodatas'] }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<div class="row gutters-10">
    <div class="col-md-4">
        <div class="card shadow-sm">
            <div class="card-header">
                <h6 class="mb-0 fs-14">{{ translate('Lead Status Distribution') }}</h6>
            </div>
            <div class="card-body">
                <canvas id="statusPie" class="w-100" height="250"></canvas>
            </div>
        </div>
    </div>
    <div class="col-md-8">
        <div class="card shadow-sm">
            <div class="card-header">
                <h6 class="mb-0 fs-14">{{ translate('Agent Performance') }}</h6>
            </div>
            <div class="card-body">
                <table class="table aiz-table mb-0">
                    <thead>
                        <tr>
                            <th>{{translate('Agent Name')}}</th>
                            <th>{{translate('Assigned Leads')}}</th>
                            <th>{{translate('Total Calls')}}</th>
                            <th class="text-success fw-600">{{translate('Biodatas Filled')}}</th>
                            <th>{{translate('Lead Performance')}}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($data['agent_performance'] as $agent)
                            <tr>
                                <td>{{$agent->first_name}} {{$agent->last_name}}</td>
                                <td>{{$agent->assigned_leads_count}}</td>
                                <td>{{ $agent->call_logs_count }}</td>
                                <td>
                                    <span class="badge badge-inline badge-soft-success p-2" style="font-size: 14px;">
                                        {{ $agent->biodatas_count }}
                                    </span>
                                </td>
                                <td>
                                    @php
                                        $calls = $agent->call_logs_count;
                                        $percent = ($agent->assigned_leads_count > 0) ? ($calls / $agent->assigned_leads_count) * 100 : 0;
                                    @endphp
                                    <div class="progress progress-sm mt-3">
                                        <div class="progress-bar" role="progressbar" style="width: {{min($percent, 100)}}%;" aria-valuenow="{{$percent}}" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <small class="text-muted">{{round($percent, 1)}}% {{translate('Leads Contacted')}}</small>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>

            </div>
        </div>
    </div>
</div>

@endsection

@section('script')
<script type="text/javascript">
    AIZ.plugins.chart('#statusPie',{
        type: 'doughnut',
        data: {
            labels: [
                @foreach($data['leads_by_status'] as $status)
                    '{{$status->status}}',
                @endforeach
            ],
            datasets: [
                {
                    data: [
                        @foreach($data['leads_by_status'] as $status)
                            {{$status->total}},
                        @endforeach
                    ],
                    backgroundColor: [
                        "#fd3995",
                        "#34bfa3",
                        "#5d78ff",
                        "#ffb822",
                        "#36a3f7",
                        "#0abb87"
                    ]
                }
            ]
        },
        options: {
            cutoutPercentage: 70,
            legend: {
                position: 'bottom'
            }
        }
    });
</script>
@endsection
