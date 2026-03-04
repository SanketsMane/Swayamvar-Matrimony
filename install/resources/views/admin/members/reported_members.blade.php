@extends('admin.layouts.app')
@section('content')
<div class="aiz-titlebar mt-2 mb-4">
    <div class="row align-items-center">
        <div class="col-md-6">
            <h1 class="h3">{{translate('Profile Reports')}}</h1>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-header">
      <h5 class="mb-md-0 h6">{{ translate('Profile Reports') }}</h5>
    </div>
    <div class="card-body">
        <table class="table aiz-table mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>{{translate('Member Name')}}</th>
                            <th>{{translate('Reported By')}}</th>
                            <th>{{translate('Report Type')}}</th>
                            <th>{{translate('Report Reason')}}</th>
                            <th class="text-right">{{translate('Option')}}</th>
                        </tr>
                    </thead>
            <tbody>
                @foreach($reports as $key => $report)
                    <tr>
                        <td>{{ ($key+1) + ($reports->currentPage() - 1)*$reports->perPage() }}</td>
                        <td>{{ $report->user->first_name.' '.$report->user->last_name}}</td>
                        <td>{{ $report->reportedBy->first_name.' '.$report->reportedBy->last_name }}</td>
                                <td>{{ $report->report_type }}</td>
                                <td>{{ $report->reason }}</td>
                                <td class="text-right">
                                    @can('block_member')
                                        @if($report->user->blocked == 0)
                                          <a href="javascript:void(0);" onclick="ban_user({{$report->user_id}})" class="btn btn-soft-primary btn-icon btn-circle btn-sm" title="{{ translate('Ban User') }}">
                                              <i class="las la-ban"></i>
                                          </a>
                                        @else
                                          <a href="javascript:void(0);" class="btn btn-soft-danger btn-icon btn-circle btn-sm" title="{{ translate('Banned') }}">
                                              <i class="las la-ban"></i>
                                          </a>
                                        @endif
                                    @endcan

                                    @can('delete_profile_report')
                                        <a href="javascript:void(0);" data-href="{{route('report_destrot.destroy_get', $report->id)}}" class="btn btn-soft-danger btn-icon btn-circle btn-sm confirm-delete" title="{{ translate('Delete') }}">
                                            <i class="las la-trash"></i>
                                        </a>
                                    @endcan
                                </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        <div class="aiz-pagination">
            {{ $reports->links() }}
        </div>
    </div>
</div>

@endsection

    @section('modal')
        {{-- Member Ban Modal --}}
        <div class="modal fade member-ban-modal" id="modal-basic">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form class="form-horizontal member-block" action="{{ route('reported_members.ban') }}" method="POST">
                        @csrf
                        <input type="hidden" name="user_id" id="user_id" value="">
                        <div class="modal-header">
                            <h5 class="modal-title h6">{{translate('Member Ban !')}}</h5>
                            <button type="button" class="close" data-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="text-center">
                                <p class="h6">{{translate('Are you sure you want to ban this member?')}}</p>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-sm btn-light" data-dismiss="modal">{{translate('Close')}}</button>
                            <button type="submit" class="btn btn-sm btn-danger">{{translate('Ban User')}}</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        @include('modals.delete_modal')
    @endsection

    @section('script')
    <script type="text/javascript">
         function ban_user(id){
             $('.member-ban-modal').modal('show');
             $('#user_id').val(id);
         }
    </script>
    @endsection
