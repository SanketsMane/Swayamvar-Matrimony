@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
	<div class="row align-items-center">
		<div class="col-md-6">
			<h1 class="h3">{{translate('All Telecallers')}}</h1>
		</div>
		<div class="col-md-6 text-md-right">
			<a href="{{ route('telecallers.create') }}" class="btn btn-circle btn-primary">
				<span>{{translate('Add New Telecaller')}}</span>
			</a>
		</div>
	</div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0 h6">{{translate('Telecallers')}}</h5>
        <div class="pull-right">
            <form id="sort_telecallers" action="" method="GET">
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
                    <th width="5%">#</th>
                    <th>{{translate('Name')}}</th>
                    <th data-breakpoints="md">{{translate('Email')}}</th>
					<th data-breakpoints="md">{{translate('Phone')}}</th>
                    <th data-breakpoints="md">{{translate('Department')}}</th>
                    <th data-breakpoints="md">{{translate('City/State')}}</th>
                    <th class="text-right">{{translate('Options')}}</th>
                </tr>
            </thead>
            <tbody>
                @foreach($telecallers as $key => $telecaller)
                    <tr>
                        <td>{{ ($key+1) + ($telecallers->currentPage() - 1)*$telecallers->perPage() }}</td>
                        <td>{{$telecaller->first_name.' '.$telecaller->last_name}}</td>
                        <td>{{$telecaller->email}}</td>
                        <td>{{$telecaller->phone}}</td>
                        <td>{{$telecaller->telecaller_detail->department ?? ''}}</td>
                        <td>
                            @if($telecaller->telecaller_detail)
                                {{$telecaller->telecaller_detail->city}}, {{$telecaller->telecaller_detail->state}}
                            @endif
                        </td>
                        <td class="text-right">
                            <a class="btn btn-soft-primary btn-icon btn-circle btn-sm" href="{{route('telecallers.performance', encrypt($telecaller->id))}}" title="{{ translate('View Performance') }}">
                                <i class="las la-chart-bar"></i>
                            </a>
                            <a class="btn btn-soft-info btn-icon btn-circle btn-sm" href="{{route('telecallers.edit', encrypt($telecaller->id))}}" title="{{ translate('Edit') }}">
                                <i class="las la-edit"></i>
                            </a>
                            <a class="btn btn-soft-warning btn-icon btn-circle btn-sm" href="#" onclick="resetPasswordModal('{{ $telecaller->id }}')" title="{{ translate('Reset Password') }}">
                                <i class="las la-key"></i>
                            </a>
                            <a href="#" class="btn btn-soft-danger btn-icon btn-circle btn-sm confirm-delete" data-href="{{route('telecallers.destroy', $telecaller->id)}}" title="{{ translate('Delete') }}">
                                <i class="las la-trash"></i>
                            </a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        <div class="aiz-pagination">
            {{ $telecallers->appends(request()->input())->links() }}
        </div>
    </div>
</div>

@endsection

@section('modal')
    <!-- Reset Password Modal -->
    <div class="modal fade" id="reset-password-modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h6">{{translate('Confirm Password Reset')}}</h5>
                    <button type="button" class="close" data-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>{{translate('Are you sure you want to reset this telecaller\'s password? A new password will be generated and emailed to them.')}}</p>
                </div>
                <div class="modal-footer">
                    <form method="POST" action="{{ route('telecallers.reset_password') }}">
                        @csrf
                        <input type="hidden" name="id" id="reset_telecaller_id" value="">
                        <button type="button" class="btn btn-light" data-dismiss="modal">{{translate('Cancel')}}</button>
                        <button type="submit" class="btn btn-primary">{{translate('Proceed')}}</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    @include('modals.delete_modal')
@endsection

@section('script')
    <script type="text/javascript">
        function resetPasswordModal(id) {
            $('#reset_telecaller_id').val(id);
            $('#reset-password-modal').modal('show');
        }
    </script>
@endsection
