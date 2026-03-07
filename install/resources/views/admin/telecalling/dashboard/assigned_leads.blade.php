@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
	<div class="row align-items-center">
		<div class="col-md-6">
			<h1 class="h3">{{translate('My Assigned Leads')}}</h1>
		</div>
	</div>
</div>

<div class="card">
    <div class="card-header">
        <h5 class="mb-0 h6">{{translate('Leads List')}}</h5>
    </div>
    <div class="card-body">
        <table class="table aiz-table mb-0">
            <thead>
                <tr>
                    <th>{{translate('Name')}}</th>
					<th>{{translate('Phone')}}</th>
                    <th data-breakpoints="md">{{translate('City')}}</th>
                    <th data-breakpoints="md">{{translate('Source')}}</th>
                    <th>{{translate('Status')}}</th>
                    <th class="text-right">{{translate('Action')}}</th>
                </tr>
            </thead>
            <tbody>
                @foreach($leads as $lead)
                    <tr @if(request('id') == $lead->id) class="table-info" @endif id="lead-{{$lead->id}}">
                        <td>{{$lead->name}}</td>
                        <td>{{$lead->mobile}}</td>
                        <td>{{$lead->city}}</td>
                        <td>{{$lead->source}}</td>
                        <td>
                            <span class="badge badge-inline badge-info">{{$lead->status}}</span>
                        </td>
                        <td class="text-right">
                            <a class="btn btn-soft-success btn-icon btn-circle btn-sm" href="javascript:void(0)" onclick="send_whatsapp('{{$lead->mobile}}', '{{$lead->name}}')" title="{{ translate('WhatsApp') }}">
                                <i class="lab la-whatsapp"></i>
                            </a>
                            <a class="btn btn-soft-primary btn-icon btn-circle btn-sm" href="javascript:void(0)" onclick="take_action('{{$lead->id}}', '{{$lead->name}}', '{{$lead->mobile}}')" title="{{ translate('Call & Action') }}">
                                <i class="las la-phone"></i>
                            </a>
                            <a class="btn btn-soft-info btn-icon btn-circle btn-sm" href="javascript:void(0)" onclick="view_history('{{$lead->id}}')" title="{{ translate('Call History') }}">
                                <i class="las la-history"></i>
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
    <!-- Action Modal -->
    <div class="modal fade" id="action-modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h6">{{translate('Take Call Action')}} - <span id="lead_name_span"></span></h5>
                    <button type="button" class="close" data-dismiss="modal"></button>
                </div>
                <form action="{{ route('telecalling.lead_action') }}" method="POST">
                    @csrf
                    <input type="hidden" name="lead_id" id="lead_id_input">
                    <div class="modal-body">
                        <div class="p-2 bg-soft-info mb-3 rounded text-center">
                            <h5 class="mb-0">{{translate('Mobile')}}: <span id="lead_mobile_span"></span></h5>
                        </div>
                        
                        <div class="form-group">
                            <label>{{translate('Call Status')}}</label>
                            <select name="status" class="form-control aiz-selectpicker" required id="call_status_select">
                                <option value="Interested">{{translate('Interested')}}</option>
                                <option value="Not Interested">{{translate('Not Interested')}}</option>
                                <option value="No Answer">{{translate('No Answer')}}</option>
                                <option value="Busy">{{translate('Busy')}}</option>
                                <option value="Call Back">{{translate('Call Back')}}</option>
                                <option value="Closed">{{translate('Closed')}}</option>
                            </select>
                        </div>

                        <div id="followup-section" style="display:none;">
                            <div class="form-group">
                                <label>{{translate('Next Followup Date')}}</label>
                                <input type="datetime-local" name="followup_date" class="form-control">
                            </div>
                            <div class="form-group">
                                <label>{{translate('Followup Notes')}}</label>
                                <textarea name="followup_notes" rows="2" class="form-control"></textarea>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>{{translate('Call Remarks/Notes')}}</label>
                            <textarea name="notes" rows="3" class="form-control" placeholder="{{translate('How was the call?')}}"></textarea>
                        </div>
                        
                        <div class="form-group">
                            <label>{{translate('Call Duration (Seconds)')}}</label>
                            <input type="number" name="duration" class="form-control" placeholder="60">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-dismiss="modal">{{translate('Cancel')}}</button>
                        <button type="submit" class="btn btn-primary">{{translate('Submit Action')}}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- History Modal -->
    <div class="modal fade" id="history-modal">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title h6">{{translate('Call History')}}</h5>
                    <button type="button" class="close" data-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="history-modal-body">
                    <!-- History will be loaded here via AJAX [Sanket] -->
                </div>
            </div>
        </div>
    </div>
@endsection

@section('script')
<script type="text/javascript">
    function take_action(id, name, mobile) {
        $('#lead_id_input').val(id);
        $('#lead_name_span').text(name);
        $('#lead_mobile_span').text(mobile);
        $('#action-modal').modal('show');
    }

    function view_history(id) {
        $.get('{{ route("call-history.lead", "") }}/' + id, function(data) {
            $('#history-modal-body').html(data);
            $('#history-modal').modal('show');
        });
    }

    function send_whatsapp(mobile, name) {
        var base_url = '{{ get_setting("telecalling_whatsapp_api_base") }}' || 'https://api.whatsapp.com/send';
        var template = '{{ get_setting("telecalling_whatsapp_message_template") }}' || 'Hello [NAME], how are you?';
        var message = template.replace('[NAME]', name).replace('[MOBILE]', mobile);
        
        window.open(base_url + '?phone=' + mobile + '&text=' + encodeURIComponent(message), '_blank');
    }

    $('#call_status_select').on('change', function() {
        if($(this).val() == 'Call Back') {
            $('#followup-section').show();
        } else {
            $('#followup-section').hide();
        }
    });

    @if(request('id'))
        $(document).ready(function() {
            var lead_id = '{{request("id")}}';
            $('html, body').animate({
                scrollTop: $("#lead-" + lead_id).offset().top - 100
            }, 500);
        });
    @endif
</script>
@endsection
