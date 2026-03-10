@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
	<div class="row align-items-center">
		<div class="col-md-6">
			<h1 class="h3">{{translate('Duplicate Leads')}}</h1>
		</div>
        <div class="col-md-6 text-md-right">
            <button class="btn btn-soft-danger" onclick="bulk_action('flush_all')">
                <i class="las la-trash"></i> {{translate('Flush All Records')}}
            </button>
            <a href="{{ route('duplicate-leads.export', request()->all()) }}" class="btn btn-soft-info">
                <i class="las la-download"></i> {{translate('Export Filtered')}}
            </a>
        </div>
	</div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0 h6">{{translate('Filter Duplicate Leads')}}</h5>
    </div>
    <div class="card-body">
        <form action="" method="GET">
            <div class="row">
                <div class="col-md-4">
                    <div class="form-group mb-0">
                        <input type="text" class="form-control" name="search" value="{{ $sort_search }}" placeholder="{{ translate('Name or Mobile & Enter') }}">
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group mb-0">
                        <input type="text" class="form-control aiz-date-range" name="date_range" value="{{ $date_range }}" placeholder="{{ translate('Select Date Range') }}" data-range="true" autocomplete="off">
                    </div>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary btn-block">{{ translate('Filter') }}</button>
                </div>
                <div class="col-md-2">
                    <a href="{{ route('duplicate-leads.index') }}" class="btn btn-light btn-block">{{ translate('Reset') }}</a>
                </div>
            </div>
        </form>
    </div>
</div>

<form id="bulk-action-form" action="{{ route('duplicate-leads.bulk_action') }}" method="POST">
    @csrf
    <input type="hidden" name="action" id="bulk-action-type" value="">
    <input type="hidden" name="campaign_id" id="bulk-campaign-id" value="">

    <div class="card">
        <div class="card-header">
            <div class="row align-items-center w-100">
                <div class="col-md-4">
                    <h5 class="mb-0 h6">{{translate('Duplicate Lead Records')}}</h5>
                </div>
                <div class="col-md-8 text-md-right">
                    <div class="d-inline-block" style="min-width: 200px;">
                        <select class="form-control aiz-selectpicker" id="action-selector">
                            <option value="">{{translate('Bulk Actions')}}</option>
                            <option value="delete">{{translate('Delete Selected')}}</option>
                            <option value="push_to_campaign">{{translate('Push to Campaign')}}</option>
                        </select>
                    </div>
                    <button type="button" class="btn btn-primary" onclick="perform_bulk_action()">{{translate('Apply')}}</button>
                </div>
            </div>
        </div>
        <div class="card-body">
            <table class="table aiz-table mb-0">
                <thead>
                    <tr>
                        <th width="50">
                            <div class="aiz-checkbox-inline">
                                <label class="aiz-checkbox">
                                    <input type="checkbox" class="check-all">
                                    <span class="aiz-square-check"></span>
                                </label>
                            </div>
                        </th>
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
                            <td>
                                <div class="aiz-checkbox-inline">
                                    <label class="aiz-checkbox">
                                        <input type="checkbox" name="lead_ids[]" value="{{ $lead->id }}" class="check-one">
                                        <span class="aiz-square-check"></span>
                                    </label>
                                </div>
                            </td>
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
</form>

@endsection

@section('modal')
    @include('modals.delete_modal')

    <div class="modal fade" id="campaign-select-modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h6">{{translate('Select Target Campaign')}}</h5>
                    <button type="button" class="close" data-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="form-group mb-3">
                        <label>{{translate('Choose Active Campaign')}}</label>
                        <select name="modal_campaign_id" id="modal_campaign_id" class="form-control aiz-selectpicker" data-live-search="true">
                            @foreach($campaigns as $campaign)
                                <option value="{{$campaign->id}}">{{$campaign->name}}</option>
                            @endforeach
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-dismiss="modal">{{translate('Close')}}</button>
                    <button type="button" class="btn btn-primary" onclick="submit_push_to_campaign()">{{translate('Push Leads')}}</button>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('script')
<script type="text/javascript">
    $(document).on('change', '.check-all', function() {
        if(this.checked) {
            $('.check-one').prop('checked', true);
        } else {
            $('.check-one').prop('checked', false);
        }
    });

    function perform_bulk_action(){
        var action = $('#action-selector').val();
        if(!action){
            AIZ.plugins.notify('warning', '{{translate('Please select an action')}}');
            return;
        }

        if($('.check-one:checked').length == 0){
            AIZ.plugins.notify('warning', '{{translate('Please select at least one lead')}}');
            return;
        }

        if(action == 'delete'){
            if(confirm('{{translate('Are you sure you want to delete selected records?')}}')){
                $('#bulk-action-type').val('delete');
                $('#bulk-action-form').submit();
            }
        } else if(action == 'push_to_campaign'){
            $('#campaign-select-modal').modal('show');
        }
    }

    function submit_push_to_campaign(){
        var campaign_id = $('#modal_campaign_id').val();
        if(!campaign_id){
            AIZ.plugins.notify('warning', '{{translate('Please select a campaign')}}');
            return;
        }
        $('#bulk-campaign-id').val(campaign_id);
        $('#bulk-action-type').val('push_to_campaign');
        $('#bulk-action-form').submit();
    }

    function bulk_action(type){
        if(type == 'flush_all'){
            if(confirm('{{translate('This will PERMANENTLY delete ALL duplicate lead records. Continue?')}}')){
                $('#bulk-action-type').val('flush_all');
                $('#bulk-action-form').submit();
            }
        }
    }
</script>
@endsection
