@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
	<div class="row align-items-center">
		<div class="col-md-6">
			<h1 class="h3">{{translate('Performance Tracking')}}: {{ $telecaller->first_name }} {{ $telecaller->last_name }}</h1>
		</div>
		<div class="col-md-6 text-md-right">
			<a href="{{ route('telecallers.index') }}" class="btn btn-circle btn-info">
				<span>{{translate('Back to Telecallers')}}</span>
			</a>
		</div>
	</div>
</div>

<div class="row">
    <!-- Biodatas Created -->
    <div class="col-lg-6">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Profiles (Biodata) Created')}}</h5>
            </div>
            <div class="card-body">
                <table class="table aiz-table mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>{{translate('Member Name')}}</th>
                            <th>{{translate('Code')}}</th>
                            <th>{{translate('Created At')}}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($biodatas as $key => $bio)
                            <tr>
                                <td>{{ ($key+1) + ($biodatas->currentPage() - 1)*$biodatas->perPage() }}</td>
                                <td>
                                    <a href="{{ route('members.show', encrypt($bio->id)) }}" target="_blank">
                                        {{ $bio->first_name }} {{ $bio->last_name }}
                                    </a>
                                </td>
                                <td>{{ $bio->code }}</td>
                                <td>{{ $bio->created_at->format('d M, Y h:i A') }}</td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="4" class="text-center">{{translate('No profiles created yet.')}}</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
                <div class="aiz-pagination">
                    {{ $biodatas->appends(request()->input())->links() }}
                </div>
            </div>
        </div>
    </div>

    <!-- Package Payments Sold -->
    <div class="col-lg-6">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Package Payments Sold')}}</h5>
            </div>
            <div class="card-body">
                <table class="table aiz-table mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>{{translate('Member')}}</th>
                            <th>{{translate('Package')}}</th>
                            <th>{{translate('Amount')}} / {{translate('Method')}}</th>
                            <th>{{translate('Date')}}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($payments as $key => $payment)
                            <tr>
                                <td>{{ ($key+1) + ($payments->currentPage() - 1)*$payments->perPage() }}</td>
                                <td>
                                    @if($payment->user)
                                        <a href="{{ route('members.show', encrypt($payment->user->id)) }}" target="_blank">
                                            {{ $payment->user->first_name }} {{ $payment->user->last_name }}
                                        </a>
                                    @else
                                        {{translate('Deleted User')}}
                                    @endif
                                </td>
                                <td>
                                    @if($payment->package)
                                        {{ $payment->package->name }}
                                    @endif
                                </td>
                                <td>
                                    <span class="badge badge-inline badge-info">{{ single_price($payment->amount) }}</span><br>
                                    <small>{{ ucfirst(str_replace('_', ' ', $payment->payment_method)) }}</small>
                                </td>
                                <td>{{ $payment->created_at->format('d M, Y') }}</td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="5" class="text-center">{{translate('No sales recorded yet.')}}</td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
                <div class="aiz-pagination">
                    {{ $payments->appends(request()->input())->links() }}
                </div>
            </div>
        </div>
    </div>
</div>

@endsection
