@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
	<div class="row align-items-center">
		<div class="col-md-6">
			<h1 class="h3">{{translate('Inactive Leads')}}</h1>
		</div>
	</div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0 h6">{{translate('Inactive Leads List')}}</h5>
        <div class="pull-right">
            <form id="sort_leads" action="" method="GET">
                <div class="box-inline pad-rgt pull-left">
                    <div class="" style="min-width: 250px;">
                        <input type="text" class="form-control" id="search" name="search" @isset($sort_search) value="{{ $sort_search }}" @endisset placeholder="{{ translate('Type name or email & Enter') }}">
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div class="card-body">
        <table class="table aiz-table mb-0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>{{translate('Name')}}</th>
					<th data-breakpoints="md">{{translate('Phone')}}</th>
                    <th>{{translate('Reason')}}</th>
                    <th data-breakpoints="md">{{translate('Marked By')}}</th>
                    <th data-breakpoints="md">{{translate('Notes')}}</th>
                    <th class="text-right">{{translate('Options')}}</th>
                </tr>
            </thead>
            <tbody>
                @foreach($leads as $key => $lead)
                    <tr>
                        <td>{{ ($key+1) + ($leads->currentPage() - 1)*$leads->perPage() }}</td>
                        <td>{{$lead->name}}</td>
                        <td>{{$lead->mobile}}</td>
                        <td><span class="badge badge-inline badge-secondary">{{$lead->reason}}</span></td>
                        <td>{{$lead->marked_by_user->first_name ?? ''}}</td>
                        <td>{{$lead->notes}}</td>
                        <td class="text-right">
                            <form action="{{route('inactive-leads.restore', $lead->id)}}" method="POST" style="display: inline-block;">
                                @csrf
                                <button type="submit" class="btn btn-soft-success btn-icon btn-circle btn-sm" title="{{ translate('Restore to Active') }}">
                                    <i class="las la-undo"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        <div class="aiz-pagination">
            {{ $leads->appends(request()->input())->links() }}
        </div>
    </div>
</div>

@endsection
