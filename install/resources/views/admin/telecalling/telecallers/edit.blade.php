@extends('admin.layouts.app')

@section('content')

<div class="col-lg-8 mx-auto">
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0 h6">{{translate('Edit Telecaller Information')}}</h5>
        </div>

        <form action="{{ route('telecallers.update', $telecaller->id) }}" method="POST">
            <input name="_method" type="hidden" value="PATCH">
            @csrf
            <div class="card-body">
                <div class="form-group row">
                    <label class="col-sm-3 col-from-label" for="first_name">{{translate('First Name')}}</label>
                    <div class="col-sm-9">
                        <input type="text" name="first_name" value="{{$telecaller->first_name}}" placeholder="{{translate('First Name')}}" id="first_name" class="form-control" required>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-3 col-from-label" for="last_name">{{translate('Last Name')}}</label>
                    <div class="col-sm-9">
                        <input type="text" name="last_name" value="{{$telecaller->last_name}}" placeholder="{{translate('Last Name')}}" id="last_name" class="form-control" required>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-3 col-from-label" for="email">{{translate('Email')}}</label>
                    <div class="col-sm-9">
                        <input type="email" name="email" value="{{$telecaller->email}}" placeholder="{{translate('Email')}}" id="email" class="form-control" required>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-3 col-from-label" for="phone">{{translate('Phone')}}</label>
                    <div class="col-sm-9">
                        <input type="text" name="phone" value="{{$telecaller->phone}}" placeholder="{{translate('Phone')}}" id="phone" class="form-control" required>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-3 col-from-label" for="department">{{translate('Department')}}</label>
                    <div class="col-sm-9">
                        <input type="text" name="department" value="{{$telecaller->telecaller_detail->department ?? ''}}" placeholder="{{translate('Department')}}" id="department" class="form-control">
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-3 col-from-label" for="pincode">{{translate('Area PIN Code')}}</label>
                    <div class="col-sm-9">
                        <input type="text" name="pincode" value="{{$telecaller->telecaller_detail->pincode ?? ''}}" placeholder="{{translate('Area PIN Code')}}" id="pincode" class="form-control">
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-3 col-from-label" for="city">{{translate('City')}}</label>
                    <div class="col-sm-9">
                        <input type="text" name="city" value="{{$telecaller->telecaller_detail->city ?? ''}}" placeholder="{{translate('City')}}" id="city" class="form-control">
                    </div>
                </div>
                <div class="form-group row">
                    <label class="col-sm-3 col-from-label" for="state">{{translate('State')}}</label>
                    <div class="col-sm-9">
                        <input type="text" name="state" value="{{$telecaller->telecaller_detail->state ?? ''}}" placeholder="{{translate('State')}}" id="state" class="form-control">
                    </div>
                </div>

                <div class="form-group row">
                    <label class="col-sm-3 col-from-label" for="coupon_code">{{translate('Coupon Code')}}</label>
                    <div class="col-sm-9">
                        <input type="text" name="coupon_code" value="{{$telecaller->telecaller_detail->coupon_code ?? ''}}" placeholder="{{translate('Unique Coupon Code')}}" id="coupon_code" class="form-control">
                        <small class="text-muted">{{translate('This code will be used by leads for discounts.')}}</small>
                    </div>
                </div>

                <div class="form-group row">
                    <label class="col-sm-3 col-from-label" for="discount_percent">{{translate('Discount Percent (%)')}}</label>
                    <div class="col-sm-9">
                        <input type="number" step="0.01" name="discount_percent" value="{{$telecaller->telecaller_detail->discount_percent ?? '0.00'}}" placeholder="{{translate('Ex: 10.00')}}" id="discount_percent" class="form-control">
                    </div>
                </div>

                <div class="form-group row">
                    <label class="col-sm-3 col-from-label" for="commission_percent">{{translate('Commission Percent (%)')}}</label>
                    <div class="col-sm-9">
                        <input type="number" step="0.01" name="commission_percent" value="{{$telecaller->telecaller_detail->commission_percent ?? '0.00'}}" placeholder="{{translate('Ex: 5.00')}}" id="commission_percent" class="form-control">
                    </div>
                </div>

                <div class="form-group mb-0 text-right">
                    <button type="submit" class="btn btn-primary">{{translate('Update')}}</button>
                </div>
            </div>
        </form>
    </div>
</div>

@endsection
