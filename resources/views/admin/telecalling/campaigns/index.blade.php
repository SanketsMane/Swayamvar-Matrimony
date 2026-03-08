@extends('admin.layouts.app')

@section('content')

<div class="row">
    <div class="col-md-7">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Campaigns')}}</h5>
            </div>
            <div class="card-body">
                <table class="table aiz-table mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>{{translate('Name')}}</th>
                            <th>{{translate('Status')}}</th>
                            <th class="text-right">{{translate('Options')}}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($campaigns as $key => $campaign)
                            <tr>
                                <td>{{ ($key+1) + ($campaigns->currentPage() - 1)*$campaigns->perPage() }}</td>
                                <td>{{$campaign->name}}</td>
                                <td>
                                    @if($campaign->status == 'active')
                                        <span class="badge badge-inline badge-success">{{translate('Active')}}</span>
                                    @else
                                        <span class="badge badge-inline badge-secondary">{{translate('Archived')}}</span>
                                    @endif
                                </td>
                                <td class="text-right">
                                    <a class="btn btn-soft-info btn-icon btn-circle btn-sm" href="javascript:void(0)" onclick="edit_campaign('{{$campaign->id}}', '{{$campaign->name}}', '{{$campaign->description}}', '{{$campaign->status}}')" title="{{ translate('Edit') }}">
                                        <i class="las la-edit"></i>
                                    </a>
                                    <a href="#" class="btn btn-soft-danger btn-icon btn-circle btn-sm confirm-delete" data-href="{{route('campaigns.destroy', $campaign->id)}}" title="{{ translate('Delete') }}">
                                        <i class="las la-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
                <div class="aiz-pagination">
                    {{ $campaigns->appends(request()->input())->links() }}
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-5">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Add New Campaign')}}</h5>
            </div>
            <div class="card-body">
                <form action="{{ route('campaigns.store') }}" method="POST">
                    @csrf
                    <div class="form-group mb-3">
                        <label for="name">{{translate('Name')}}</label>
                        <input type="text" id="name" name="name" placeholder="{{ translate('Campaign Name') }}" class="form-control" required>
                    </div>
                    <div class="form-group mb-3">
                        <label for="description">{{translate('Description')}}</label>
                        <textarea name="description" rows="5" class="form-control" placeholder="{{translate('Description')}}"></textarea>
                    </div>
                    <div class="form-group mb-3 text-right">
                        <button type="submit" class="btn btn-primary">{{translate('Save')}}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

@endsection

@section('modal')
    @include('modals.delete_modal')

    <div class="modal fade" id="edit-modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h6">{{translate('Edit Campaign')}}</h5>
                    <button type="button" class="close" data-dismiss="modal"></button>
                </div>
                <form id="edit-form" action="" method="POST">
                    <input name="_method" type="hidden" value="PATCH">
                    @csrf
                    <div class="modal-body">
                        <div class="form-group mb-3">
                            <label for="edit_name">{{translate('Name')}}</label>
                            <input type="text" id="edit_name" name="name" class="form-control" required>
                        </div>
                        <div class="form-group mb-3">
                            <label for="edit_description">{{translate('Description')}}</label>
                            <textarea id="edit_description" name="description" rows="5" class="form-control"></textarea>
                        </div>
                        <div class="form-group mb-3">
                            <label for="edit_status">{{translate('Status')}}</label>
                            <select name="status" id="edit_status" class="form-control aiz-selectpicker">
                                <option value="active">{{translate('Active')}}</option>
                                <option value="archived">{{translate('Archived')}}</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-dismiss="modal">{{translate('Close')}}</button>
                        <button type="submit" class="btn btn-primary">{{translate('Update')}}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
@endsection

@section('script')
    <script type="text/javascript">
        function edit_campaign(id, name, description, status){
            var url = '{{ route("campaigns.update", ":id") }}';
            url = url.replace(':id', id);
            $('#edit-form').attr('action', url);
            
            $('#edit_name').val(name);
            $('#edit_description').val(description);
            $('#edit_status').val(status);
            $('.aiz-selectpicker').selectpicker('refresh');
            
            $('#edit-modal').modal('show');
        }
    </script>
@endsection
