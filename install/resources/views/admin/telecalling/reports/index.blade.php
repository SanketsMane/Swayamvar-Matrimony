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
                            <th>{{translate('Performance')}}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($data['agent_performance'] as $agent)
                            <tr>
                                <td>{{$agent->first_name}} {{$agent->last_name}}</td>
                                <td>{{$agent->assigned_leads_count}}</td>
                                <td>{{ $agent->call_logs_count }}</td>
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
