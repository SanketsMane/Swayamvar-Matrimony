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
                    <th>{{translate('Campaign')}}</th>
                    <th>{{translate('Upload ID')}}</th>
                    <th class="text-right">{{translate('Options')}}</th>
                </tr>
            </thead>
            <tbody>
                @foreach($leads as $key => $lead)
                    <tr>
                        <td>{{ ($key+1) + ($leads->currentPage() - 1)*$leads->perPage() }}</td>
                        <td>{{$lead->name}}</td>
                        <td>{{$lead->mobile}}</td>
                        <td>{{ $lead->upload->campaign->name ?? 'N/A' }}</td>
                        <td>#{{$lead->upload_id}}</td>
                        <td class="text-right">
                            <button class="btn btn-soft-primary btn-icon btn-circle btn-sm" onclick="show_details('{{ $lead->id }}')" title="{{ translate('View Original Data') }}">
                                <i class="las la-eye"></i>
                            </button>
                            <a href="{{ route('duplicate-leads.resolve', ['id' => $lead->id, 'action' => 'force_import']) }}" class="btn btn-soft-success btn-icon btn-circle btn-sm confirm-force" title="{{ translate('Force Import as New') }}">
                                <i class="las la-plus-circle"></i>
                            </a>
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

<div class="modal fade" id="details-modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title h6">{{ translate('Duplicate Lead Original Data') }}</h5>
                <button type="button" class="close" data-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="details-content">
                    <div class="text-center">
                        <div class="spinner-border text-primary" role="status">
                            <span class="sr-only">Loading...</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="force-modal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title h6">{{ translate('Confirm Force Import') }}</h5>
                <button type="button" class="close" data-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center">
                <p class="mt-1">{{translate('Are you sure you want to import this duplicate as a new lead?')}}</p>
                <button type="button" class="btn btn-light mt-2" data-dismiss="modal">{{translate('Cancel')}}</button>
                <a href="" id="force-link" class="btn btn-success mt-2">{{translate('Proceed')}}</a>
            </div>
        </div>
    </div>
</div>

@endsection

@section('modal')
    @include('modals.delete_modal')
@endsection

@section('script')
<script type="text/javascript">
    function show_details(id){
        $('#details-content').html('<div class="text-center"><div class="spinner-border text-primary" role="status"><span class="sr-only">Loading...</span></div></div>');
        $('#details-modal').modal('show');
        $.get('{{ route('duplicate-leads.show_api', '') }}/' + id, function(data){
            var html = '<table class="table table-bordered">';
            html += '<tr><th>Field</th><th>Value</th></tr>';
            html += '<tr><td>Mobile</td><td>' + data.mobile + '</td></tr>';
            html += '<tr><td>Detected Name</td><td>' + data.name + '</td></tr>';
            
            // Show all original Data [Sanket]
            if(data.data && data.data.length > 0) {
                html += '<tr><th colspan="2" class="bg-light text-center">Original Row Data</th></tr>';
                data.data.forEach(function(val, index) {
                    html += '<tr><td>Col ' + (index+1) + '</td><td>' + (val ? val : '-') + '</td></tr>';
                });
            }
            html += '</table>';
            $('#details-content').html(html);
        });
    }

    $(document).on('click', '.confirm-force', function(e){
        e.preventDefault();
        var url = $(this).attr('href');
        $('#force-link').attr('href', url);
        $('#force-modal').modal('show');
    });
</script>
@endsection
