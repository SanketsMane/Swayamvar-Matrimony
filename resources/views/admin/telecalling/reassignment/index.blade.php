@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
    <div class="row align-items-center">
        <div class="col-md-6">
            <h1 class="h3">{{translate('Lead Reassignment')}}</h1>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-lg-12">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Reassign Leads between Telecallers')}}</h5>
            </div>
            <div class="card-body">
                <div class="row mb-3">
                    <div class="col-md-5">
                        <label>{{translate('Select Current Telecaller')}}</label>
                        <select id="current_agent" class="form-control aiz-selectpicker" data-live-search="true">
                            <option value="">{{translate('Choose Telecaller')}}</option>
                            @foreach($telecallers as $telecaller)
                                <option value="{{$telecaller->id}}">{{$telecaller->first_name}} {{$telecaller->last_name}}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="col-md-2 text-center pt-4">
                        <i class="las la-exchange-alt la-3x text-muted"></i>
                    </div>
                    <div class="col-md-5">
                        <label>{{translate('Select New Telecaller')}}</label>
                        <select id="new_agent" class="form-control aiz-selectpicker" data-live-search="true">
                            <option value="">{{translate('Choose Telecaller')}}</option>
                            @foreach($telecallers as $telecaller)
                                <option value="{{$telecaller->id}}">{{$telecaller->first_name}} {{$telecaller->last_name}}</option>
                            @endforeach
                        </select>
                    </div>
                </div>

                <form id="reassign-form" action="{{ route('reassignment.process') }}" method="POST">
                    @csrf
                    <input type="hidden" name="new_agent_id" id="new_agent_id_hidden">
                    
                    <div id="reassign-lead-list">
                        <div class="text-center p-5 text-muted border">
                            {{translate('Select a telecaller to view their assigned leads')}}
                        </div>
                    </div>

                    <div class="text-right mt-3">
                        <button type="submit" class="btn btn-primary" id="reassign-btn" disabled>{{translate('Process Reassignment')}}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

@endsection

@section('script')
<script type="text/javascript">
    $('#current_agent').on('change', function() {
        var agent_id = $(this).val();
        if(agent_id) {
            $.get('{{ route("reassignment.get_leads") }}', {telecaller_id: agent_id}, function(data) {
                $('#reassign-lead-list').html(data);
                checkBtnState();
            });
        }
    });

    $('#new_agent').on('change', function() {
        $('#new_agent_id_hidden').val($(this).val());
        checkBtnState();
    });

    function checkBtnState() {
        if($('#new_agent').val() && $('input[name="lead_ids[]"]:checked').length > 0) {
            $('#reassign-btn').removeAttr('disabled');
        } else {
            $('#reassign-btn').attr('disabled', 'disabled');
        }
    }

    $(document).on('change', 'input[name="lead_ids[]"]', function() {
        checkBtnState();
    });

    function selectAllLeads(source) {
        checkboxes = document.getElementsByName('lead_ids[]');
        for(var i=0, n=checkboxes.length; i<n; i++) {
            checkboxes[i].checked = source.checked;
        }
        checkBtnState();
    }
</script>
@endsection
