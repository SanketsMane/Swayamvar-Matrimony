@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
    <div class="row align-items-center">
        <div class="col-md-6">
            <h1 class="h3">{{translate('Meta Lead Integration')}}</h1>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0 h6">{{translate('Meta Leads')}}</h5>
    </div>
    <div class="card-body">
        <table class="table aiz-table mb-0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>{{translate('Name')}}</th>
                    <th>{{translate('Email')}}</th>
                    <th>{{translate('Phone')}}</th>
                    <th>{{translate('Assigned To')}}</th>
                    <th>{{translate('Sync Date')}}</th>
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
                        <td>{{$lead->created_at->format('d-m-Y H:i A')}}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        <div class="aiz-pagination">
            {{ $leads->appends(request()->input())->links() }}
        </div>
    </div>
</div>

<div class="alert alert-info">
    {{translate('Note: Leads from Meta Lead Ads are automatically synced via the webhook. You can configure Meta Ads credentials in Telecalling Settings.')}}
</div>

@endsection
