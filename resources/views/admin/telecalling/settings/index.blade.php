@extends('admin.layouts.app')

@section('content')

<div class="row">
    <div class="col-lg-8 mx-auto">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Telecalling General Settings')}}</h5>
            </div>
            <div class="card-body">
                <form action="{{ route('telecalling.settings_update') }}" method="POST">
                    @csrf
                    <input type="hidden" name="types[]" value="telecalling_whatsapp_api_base">
                    <div class="form-group mb-3">
                        <label>{{translate('WhatsApp API Base URL')}}</label>
                        <input type="text" name="telecalling_whatsapp_api_base" class="form-control" value="{{ get_setting('telecalling_whatsapp_api_base') }}" placeholder="https://api.whatsapp.com/send">
                    </div>

                    <input type="hidden" name="types[]" value="telecalling_whatsapp_message_template">
                    <div class="form-group mb-3">
                        <label>{{translate('WhatsApp Message Template')}}</label>
                        <textarea name="telecalling_whatsapp_message_template" rows="4" class="form-control">{{ get_setting('telecalling_whatsapp_message_template') }}</textarea>
                        <small class="text-muted">{{translate('Available placeholders: [NAME], [MOBILE], [OTP]')}}</small>
                    </div>
                    <hr>
                    <h5 class="mb-3 h6">{{translate('Meta Lead Ads Integration')}}</h5>
                    
                    <input type="hidden" name="types[]" value="meta_app_id">
                    <div class="form-group mb-3">
                        <label>{{translate('Meta App ID')}}</label>
                        <input type="text" name="meta_app_id" class="form-control" value="{{ get_setting('meta_app_id') }}" placeholder="Enter Meta App ID">
                    </div>

                    <input type="hidden" name="types[]" value="meta_app_secret">
                    <div class="form-group mb-3">
                        <label>{{translate('Meta App Secret')}}</label>
                        <input type="text" name="meta_app_secret" class="form-control" value="{{ get_setting('meta_app_secret') }}" placeholder="Enter Meta App Secret">
                    </div>

                    <input type="hidden" name="types[]" value="meta_page_access_token">
                    <div class="form-group mb-3">
                        <label>{{translate('Meta Page Access Token')}}</label>
                        <input type="text" name="meta_page_access_token" class="form-control" value="{{ get_setting('meta_page_access_token') }}" placeholder="Enter Meta Page Access Token">
                    </div>

                    <input type="hidden" name="types[]" value="meta_webhook_verify_token">
                    <div class="form-group mb-3">
                        <label>{{translate('Webhook Verify Token')}}</label>
                        <input type="text" name="meta_webhook_verify_token" class="form-control" value="{{ get_setting('meta_webhook_verify_token') }}" placeholder="Enter Verify Token">
                    </div>

                    <div class="text-right">
                        <button type="submit" class="btn btn-primary">{{translate('Save Settings')}}</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Campaign Management')}}</h5>
            </div>
            <div class="card-body text-center">
                <p>{{translate('Manage your telecalling campaigns here.')}}</p>
                <a href="{{ route('campaigns.index') }}" class="btn btn-info">{{translate('Go to Campaigns')}}</a>
            </div>
        </div>
    </div>
</div>

@endsection
