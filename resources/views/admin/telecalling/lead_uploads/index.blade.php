@extends('admin.layouts.app')

@section('content')

<div class="row">
    <div class="col-md-8">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Previous Lead Uploads')}}</h5>
            </div>
            <div class="card-body">
                <table class="table aiz-table mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>{{translate('File Name')}}</th>
                            <th>{{translate('Campaign')}}</th>
                            <th data-breakpoints="md">{{translate('Total')}}</th>
                            <th data-breakpoints="md">{{translate('Valid')}}</th>
                            <th data-breakpoints="md">{{translate('Duplicate')}}</th>
                            <th data-breakpoints="md">{{translate('Invalid')}}</th>
                            <th class="text-right">{{translate('Options')}}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($uploads as $key => $upload)
                            <tr>
                                <td>{{ ($key+1) + ($uploads->currentPage() - 1)*$uploads->perPage() }}</td>
                                <td>{{$upload->file_name}}</td>
                                <td>{{$upload->campaign->name ?? ''}}</td>
                                <td>{{$upload->total_leads}}</td>
                                <td><span class="text-success">{{$upload->valid_leads}}</span></td>
                                <td><span class="text-warning">{{$upload->duplicate_leads}}</span></td>
                                <td><span class="text-danger">{{$upload->invalid_leads}}</span></td>
                                <td class="text-right">
                                    <a href="#" class="btn btn-soft-danger btn-icon btn-circle btn-sm confirm-delete" data-href="{{route('lead-upload.destroy', $upload->id)}}" title="{{ translate('Delete') }}">
                                        <i class="las la-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
                <div class="aiz-pagination">
                    {{ $uploads->appends(request()->input())->links() }}
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        @if(session('import_stats'))
            <div class="card bg-soft-info mb-3">
                <div class="card-header">
                    <h5 class="mb-0 h6">{{translate('Latest Import Stats')}}</h5>
                </div>
                <div class="card-body">
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item d-flex justify-content-between align-items-center bg-transparent">
                            {{translate('Total Leads')}}
                            <span class="badge badge-primary badge-pill">{{session('import_stats')['total']}}</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center bg-transparent">
                            {{translate('Valid Leads')}}
                            <span class="badge badge-success badge-pill">{{session('import_stats')['valid']}}</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center bg-transparent">
                            {{translate('Duplicate Leads')}}
                            <span class="badge badge-warning badge-pill">{{session('import_stats')['duplicate']}}</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center bg-transparent">
                            {{translate('Invalid Leads')}}
                            <span class="badge badge-danger badge-pill">{{session('import_stats')['invalid']}}</span>
                        </li>
                    </ul>
                </div>
            </div>
        @endif

        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Upload New Leads')}}</h5>
            </div>
            <div class="card-body">
                <form action="{{ route('lead-upload.store') }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    <div class="form-group mb-3">
                        <label for="campaign_id">{{translate('Select Campaign')}}</label>
                        <select name="campaign_id" id="campaign_id" class="form-control aiz-selectpicker" required data-live-search="true">
                            @foreach($campaigns as $campaign)
                                <option value="{{$campaign->id}}">{{$campaign->name}}</option>
                            @endforeach
                        </select>
                    </div>
                    <div class="form-group mb-3">
                        <label for="lead_file">{{translate('Excel/CSV File')}}</label>
                        <div class="custom-file">
                            <label class="custom-file-label">
                                <input type="file" name="lead_file" class="custom-file-input" required>
                                <span class="custom-file-name">{{ translate('Choose file') }}</span>
                            </label>
                        </div>
                        <small class="text-muted">{{translate('Supported formats: .xlsx, .xls, .csv')}}</small>
                    </div>
                    <div class="form-group mb-3 text-right">
                        <button type="submit" class="btn btn-primary">{{translate('Upload & Process')}}</button>
                    </div>
                </form>
                <hr>
                <div class="alert alert-info py-2">
                    <h6 class="h6 mb-2">{{translate('Instructions')}}:</h6>
                    <ul class="mb-0 pl-3">
                        <li>{{translate('First row should be the header.')}}</li>
                        <li>{{translate('Columns: Name, Email, Mobile, City, Pincode, Source, Business Type')}}</li>
                        <li>{{translate('Mobile number must be 10 digits.')}}</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

@endsection

@section('modal')
    @include('modals.delete_modal')
@endsection
