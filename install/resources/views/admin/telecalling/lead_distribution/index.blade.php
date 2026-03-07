@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
    <div class="row align-items-center">
        <div class="col-md-6">
            <h1 class="h3">{{translate('Lead Distribution')}}</h1>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-6">
        <!-- Equal Distribution -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Equal Distribution')}}</h5>
            </div>
            <div class="card-body">
                <form action="{{ route('lead-distribution.equal') }}" method="POST">
                    @csrf
                    <div class="form-group mb-3">
                        <label>{{translate('Select Campaign')}}</label>
                        <select name="campaign_id" class="form-control aiz-selectpicker" required data-live-search="true">
                            @foreach($campaigns as $campaign)
                                <option value="{{$campaign->id}}">{{$campaign->name}}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="form-group mb-3">
                        <label>{{translate('Select Telecallers')}}</label>
                        <select name="telecaller_ids[]" class="form-control aiz-selectpicker" multiple required data-live-search="true">
                            @foreach($telecallers as $telecaller)
                                <option value="{{$telecaller->id}}">{{$telecaller->first_name}} {{$telecaller->last_name}}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="text-right">
                        <button type="submit" class="btn btn-primary">{{translate('Distribute Equally')}}</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- PIN Code based Distribution -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('PIN Code based Distribution')}}</h5>
            </div>
            <div class="card-body">
                <form action="{{ route('lead-distribution.pincode') }}" method="POST">
                    @csrf
                    <div class="form-group mb-3">
                        <label>{{translate('Select Campaign')}}</label>
                        <select name="campaign_id" class="form-control aiz-selectpicker" required data-live-search="true">
                            @foreach($campaigns as $campaign)
                                <option value="{{$campaign->id}}">{{$campaign->name}}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="alert alert-info py-2">
                        {{translate('Leads will be assigned to telecallers matching their Area PIN Code.')}}
                    </div>
                    <div class="text-right">
                        <button type="submit" class="btn btn-info">{{translate('Distribute by PIN')}}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="col-md-6">
        <!-- Manual Distribution -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Manual Distribution')}}</h5>
            </div>
            <div class="card-body">
                <div class="form-group mb-3">
                    <label>{{translate('Select Campaign to Load Leads')}}</label>
                    <select id="campaign_manual" class="form-control aiz-selectpicker" data-live-search="true">
                        <option value="">{{translate('Choose Campaign')}}</option>
                        @foreach($campaigns as $campaign)
                            <option value="{{$campaign->id}}">{{$campaign->name}}</option>
                        @endforeach
                    </select>
                </div>

                <form action="{{ route('lead-distribution.manual') }}" method="POST">
                    @csrf
                    <div id="lead-list-container">
                        <div class="text-center p-3 text-muted">
                            {{translate('Please select a campaign to view unassigned leads')}}
                        </div>
                    </div>

                    <div class="form-group mt-3">
                        <label>{{translate('Assign Selected to Telecaller')}}</label>
                        <select name="telecaller_id" class="form-control aiz-selectpicker" data-live-search="true">
                            @foreach($telecallers as $telecaller)
                                <option value="{{$telecaller->id}}">{{$telecaller->first_name}} {{$telecaller->last_name}}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="text-right">
                        <button type="submit" class="btn btn-success">{{translate('Assign Manually')}}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

@endsection

@section('script')
<script type="text/javascript">
    $('#campaign_manual').on('change', function() {
        var campaign_id = $(this).val();
        if(campaign_id) {
            $.get('{{ route("lead-distribution.get_leads") }}', {campaign_id: campaign_id}, function(data) {
                $('#lead-list-container').html(data);
                AIZ.plugins.fooTable(); // Re-init footable if used
            });
        }
    });

    function selectAllLeads(source) {
        checkboxes = document.getElementsByName('lead_ids[]');
        for(var i=0, n=checkboxes.length; i<n; i++) {
            checkboxes[i].checked = source.checked;
        }
    }
</script>
@endsection
