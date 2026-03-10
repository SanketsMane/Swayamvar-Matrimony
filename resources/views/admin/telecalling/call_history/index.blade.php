@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
	<div class="row align-items-center">
		<div class="col-md-6">
			<h1 class="h3">{{translate('Call History')}}</h1>
		</div>
	</div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0 h6">{{translate('Logs')}}</h5>
    </div>
    <div class="card-body">
        <table class="table aiz-table mb-0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>{{translate('Lead Name')}}</th>
                    <th>{{translate('Agent')}}</th>
					<th>{{translate('Status')}}</th>
                    <th>{{translate('Duration')}}</th>
                    <th>{{translate('Date & Time')}}</th>
                    <th>{{translate('Notes')}}</th>
                </tr>
            </thead>
            <tbody>
                @foreach($logs as $key => $log)
                    <tr>
                        <td>{{ ($key+1) + ($logs->currentPage() - 1)*$logs->perPage() }}</td>
                        <td>{{$log->lead->name ?? ''}}</td>
                        <td>{{$log->agent->first_name ?? ''}}</td>
                        <td>
                            <span class="badge badge-inline badge-info">{{$log->status}}</span>
                        </td>
                        <td>{{$log->duration}}s</td>
                        <td>{{$log->call_time->format('Y-m-d H:i')}}</td>
                        <td>{{$log->notes}}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        <div class="aiz-pagination">
            {{ $logs->appends(request()->input())->links() }}
        </div>
    </div>
</div>

@endsection
