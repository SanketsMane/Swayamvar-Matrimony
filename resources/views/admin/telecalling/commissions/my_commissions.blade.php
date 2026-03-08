@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
    <div class="row align-items-center">
        <div class="col-md-6">
            <h1 class="h3">{{translate('My Commission History')}}</h1>
        </div>
    </div>
</div>

<div class="row gutters-10 mb-3">
    <div class="col-md-4">
        <div class="card bg-soft-info mb-4">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="icon-shape icon-md bg-info text-white rounded-circle mr-3">
                        <i class="las la-ticket-alt"></i>
                    </div>
                    <div>
                        <h6 class="mb-0 fs-14">{{translate('My Coupon Code')}}</h6>
                        <div class="fs-18 fw-700 text-info" id="agent_coupon">{{ $telecaller_details->coupon_code ?? 'None' }}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card bg-soft-success mb-4">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="icon-shape icon-md bg-success text-white rounded-circle mr-3">
                        <i class="las la-hand-holding-usd"></i>
                    </div>
                    <div>
                        <h6 class="mb-0 fs-14">{{translate('Total Commission Earned')}}</h6>
                        <div class="fs-18 fw-700 text-success">{{ format_price($total_commission) }}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0 h6">{{translate('Commission Records')}}</h5>
    </div>
    <div class="card-body">
        <table class="table aiz-table mb-0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>{{translate('User')}}</th>
                    <th>{{translate('Coupon Used')}}</th>
                    <th>{{translate('Discount Given')}}</th>
                    <th>{{translate('My Commission')}}</th>
                    <th>{{translate('Date')}}</th>
                </tr>
            </thead>
            <tbody>
                @foreach($usages as $key => $usage)
                    <tr>
                        <td>{{ ($key+1) + ($usages->currentPage() - 1)*$usages->perPage() }}</td>
                        <td>{{$usage->user->first_name ?? ''}} {{$usage->user->last_name ?? ''}}</td>
                        <td>{{$usage->coupon_code}}</td>
                        <td>{{format_price($usage->discount_amount)}}</td>
                        <td><span class="text-success fw-600">+{{format_price($usage->commission_amount)}}</span></td>
                        <td>{{$usage->created_at->format('d-m-Y H:i A')}}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        <div class="aiz-pagination">
            {{ $usages->appends(request()->input())->links() }}
        </div>
    </div>
</div>

@endsection
