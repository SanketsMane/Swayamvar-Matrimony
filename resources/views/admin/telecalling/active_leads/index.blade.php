@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
    <div class="row align-items-center">
        <div class="col-md-6">
            <h1 class="h3">{{translate('Active Leads')}}</h1>
        </div>
        <div class="col-md-6 text-md-right">
            <a href="{{ route('active-leads.create') }}" class="btn btn-primary">
                <span>{{translate('Add Manual Lead')}}</span>
            </a>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0 h6">{{translate('All Leads')}}</h5>
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
                    <th data-breakpoints="md">{{translate('Email')}}</th>
					<th data-breakpoints="md">{{translate('Phone')}}</th>
                    <th>{{translate('Assigned To')}}</th>
                    <th>{{translate('Status')}}</th>
                    <th class="text-right">{{translate('Options')}}</th>
                </tr>
            </thead>
            <tbody>
                @foreach($leads as $key => $lead)
                    <tr>
                        <td>{{ ($key+1) + ($leads->currentPage() - 1)*$leads->perPage() }}</td>
                        <td>{{$lead->name}}</td>
                        <td>{{$lead->email}}</td>
                        <td>{{$lead->mobile}}</td>
                        <td>{{$lead->assigned_agent->first_name ?? translate('Unassigned')}}</td>
                        <td>
                            <span class="badge badge-inline badge-info">{{$lead->status}}</span>
                        </td>
                        <td class="text-right">
                            <a class="btn btn-soft-warning btn-icon btn-circle btn-sm" href="javascript:void(0)" onclick="mark_inactive('{{$lead->id}}')" title="{{ translate('Mark Inactive') }}">
                                <i class="las la-times-circle"></i>
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
    <div class="modal fade" id="inactive-modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h6">{{translate('Mark Lead as Inactive')}}</h5>
                    <button type="button" class="close" data-dismiss="modal"></button>
                </div>
                <form id="inactive-form" action="" method="POST">
                    @csrf
                    <div class="modal-body">
                        <div class="form-group mb-3">
                            <label for="reason">{{translate('Reason')}}</label>
                            <select name="reason" class="form-control aiz-selectpicker" required>
                                <option value="Wrong Number">{{translate('Wrong Number')}}</option>
                                <option value="Not Interested">{{translate('Not Interested')}}</option>
                                <option value="Already Registered">{{translate('Already Registered')}}</option>
                                <option value="Invalid Data">{{translate('Invalid Data')}}</option>
                                <option value="Other">{{translate('Other')}}</option>
                            </select>
                        </div>
                        <div class="form-group mb-3">
                            <label for="notes">{{translate('Notes')}}</label>
                            <textarea name="notes" rows="4" class="form-control" placeholder="{{translate('Additional notes...')}}"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-dismiss="modal">{{translate('Close')}}</button>
                        <button type="submit" class="btn btn-danger">{{translate('Mark Inactive')}}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
@endsection

@section('script')
    <script type="text/javascript">
        function mark_inactive(id){
            var url = '{{ route("active-leads.mark_inactive", ":id") }}';
            url = url.replace(':id', id);
            $('#inactive-form').attr('action', url);
            $('#inactive-modal').modal('show');
        }
    </script>
@endsection
