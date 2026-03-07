@extends('admin.layouts.app')

@section('content')

<div class="row">
    <div class="col-lg-8 mx-auto">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Add Offline Lead Manually')}}</h5>
            </div>
            <div class="card-body">
                <form action="{{ route('active-leads.store') }}" method="POST">
                    @csrf
                    <div class="form-group row">
                        <label class="col-md-3 col-from-label">{{translate('Name')}} <span class="text-danger">*</span></label>
                        <div class="col-md-9">
                            <input type="text" name="name" class="form-control" placeholder="{{translate('Full Name')}}" required>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-3 col-from-label">{{translate('Mobile/Phone')}} <span class="text-danger">*</span></label>
                        <div class="col-md-9">
                            <input type="text" name="mobile" class="form-control" placeholder="{{translate('Mobile Number')}}" required>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-3 col-from-label">{{translate('Email')}}</label>
                        <div class="col-md-9">
                            <input type="email" name="email" class="form-control" placeholder="{{translate('Email Address')}}">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-3 col-from-label">{{translate('City')}}</label>
                        <div class="col-md-9">
                            <input type="text" name="city" class="form-control" placeholder="{{translate('City')}}">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-3 col-from-label">{{translate('PIN Code')}}</label>
                        <div class="col-md-9">
                            <input type="text" name="pincode" class="form-control" placeholder="{{translate('PIN Code')}}">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-3 col-from-label">{{translate('Source')}}</label>
                        <div class="col-md-9">
                            <input type="text" name="source" class="form-control" placeholder="{{translate('Ex: Walk-in, Reference')}}" value="Offline / Manual">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label class="col-md-3 col-from-label">{{translate('Business Type')}}</label>
                        <div class="col-md-9">
                            <input type="text" name="business_type" class="form-control" placeholder="{{translate('Ex: Premium, Basic')}}">
                        </div>
                    </div>
                    
                    <div class="form-group row">
                        <label class="col-md-3 col-from-label">{{translate('Campaign')}} <span class="text-danger">*</span></label>
                        <div class="col-md-9">
                            <select name="campaign_id" class="form-control aiz-selectpicker" required>
                                <option value="">{{translate('Select Campaign')}}</option>
                                @foreach($campaigns as $campaign)
                                    <option value="{{ $campaign->id }}">{{ $campaign->name }}</option>
                                @endforeach
                            </select>
                        </div>
                    </div>

                    <div class="form-group row">
                        <label class="col-md-3 col-from-label">{{translate('Assign Directly To')}}</label>
                        <div class="col-md-9">
                            <select name="assigned_to" class="form-control aiz-selectpicker" data-live-search="true">
                                <option value="">{{translate('Unassigned')}}</option>
                                @foreach($telecallers as $telecaller)
                                    <option value="{{ $telecaller->id }}">{{ $telecaller->first_name }} {{ $telecaller->last_name }}</option>
                                @endforeach
                            </select>
                        </div>
                    </div>

                    <div class="form-group mb-0 text-right">
                        <button type="submit" class="btn btn-primary">{{translate('Save Lead')}}</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

@endsection
