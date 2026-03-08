@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
	<div class="row align-items-center">
		<div class="col-md-6">
			<h1 class="h3">{{translate('Duplicate Leads')}}</h1>
		</div>
	</div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0 h6">{{translate('Duplicate Lead Records')}}</h5>
    </div>
    <div class="card-body">
        <table class="table aiz-table mb-0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>{{translate('Name')}}</th>
					<th>{{translate('Mobile')}}</th>
                    <th>{{translate('Upload ID')}}</th>
                    <th>{{translate('Detected At')}}</th>
                    <th class="text-right">{{translate('Options')}}</th>
                </tr>
            </thead>
            <tbody>
                @foreach($leads as $key => $lead)
                    <tr>
                        <td>{{ ($key+1) + ($leads->currentPage() - 1)*$leads->perPage() }}</td>
                        <td>{{$lead->name}}</td>
                        <td>{{$lead->mobile}}</td>
                        <td>#{{$lead->upload_id}}</td>
                        <td>{{$lead->created_at->format('Y-m-d H:i')}}</td>
                        <td class="text-right">
                            <a href="#" class="btn btn-soft-danger btn-icon btn-circle btn-sm confirm-delete" data-href="{{route('duplicate-leads.destroy', $lead->id)}}" title="{{ translate('Delete Record') }}">
                                <i class="las la-trash"></i>
                            </a>
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

@section('modal')
    @include('modals.delete_modal')
@endsection
