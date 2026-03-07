@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
    <div class="row align-items-center">
        <div class="col-md-6">
            <h1 class="h3">{{translate('Telecaller Commission History')}}</h1>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0 h6">{{translate('Commission Records')}}</h5>
        <div class="pull-right">
            <form id="sort_commissions" action="" method="GET">
                <div class="box-inline pad-rgt pull-left">
                    <div class="" style="min-width: 200px;">
                        <select class="form-control aiz-selectpicker" name="agent_id" id="agent_id" onchange="sort_commissions()">
                            <option value="">{{translate('Filter By Agent')}}</option>
                            @foreach($agents as $agent)
                                <option value="{{$agent->id}}" @if($agent->id == $sort_agent) selected @endif>{{$agent->first_name}} {{$agent->last_name}}</option>
                            @endforeach
                        </select>
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
                    <th>{{translate('Agent')}}</th>
                    <th>{{translate('User')}}</th>
                    <th>{{translate('Coupon')}}</th>
                    <th>{{translate('Discount')}}</th>
                    <th>{{translate('Commission')}}</th>
                    <th>{{translate('Date')}}</th>
                </tr>
            </thead>
            <tbody>
                @foreach($usages as $key => $usage)
                    <tr>
                        <td>{{ ($key+1) + ($usages->currentPage() - 1)*$usages->perPage() }}</td>
                        <td>{{$usage->telecaller->first_name ?? ''}} {{$usage->telecaller->last_name ?? ''}}</td>
                        <td>{{$usage->user->first_name ?? ''}} {{$usage->user->last_name ?? ''}}</td>
                        <td>{{$usage->coupon_code}}</td>
                        <td>{{format_price($usage->discount_amount)}}</td>
                        <td>{{format_price($usage->commission_amount)}}</td>
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

@section('script')
    <script type="text/javascript">
        function sort_commissions(el){
            $('#sort_commissions').submit();
        }
    </script>
@endsection
