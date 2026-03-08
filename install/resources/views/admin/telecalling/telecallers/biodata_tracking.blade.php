@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
    <div class="row align-items-center">
        <div class="col-md-6">
            <h1 class="h3">{{ translate('Biodata Tracking') }}</h1>
            <p class="text-muted fs-12">All member biodatas submitted by telecallers</p>
        </div>
        <div class="col-md-6 text-right">
            {{-- Total count badge --}}
            <span class="badge badge-lg badge-primary px-4 py-2" style="font-size: 14px;">
                {{ $biodatas->total() }} {{ translate('Total Biodatas') }}
            </span>
        </div>
    </div>
</div>

{{-- Filters --}}
<div class="card mb-4">
    <div class="card-body">
        <form action="{{ route('telecallers.biodata_tracking') }}" method="GET" class="form-inline" id="searchForm">
            <div class="row w-100 gutters-10">
                <div class="col-md-5 mb-2">
                    <input type="text" name="search" value="{{ $search }}"
                        class="form-control w-100" placeholder="{{ translate('Search by name, phone, code') }}">
                </div>
                <div class="col-md-4 mb-2">
                    <select name="telecaller_id" class="form-control w-100">
                        <option value="">{{ translate('All Telecallers') }}</option>
                        @foreach($telecallers as $tc)
                            <option value="{{ $tc->id }}" {{ $telecaller_filter == $tc->id ? 'selected' : '' }}>
                                {{ $tc->first_name }} {{ $tc->last_name }}
                            </option>
                        @endforeach
                    </select>
                </div>
                <div class="col-md-3 mb-2 d-flex">
                    <button type="submit" class="btn btn-primary mr-2">
                        <i class="las la-search mr-1"></i>{{ translate('Filter') }}
                    </button>
                    <a href="{{ route('telecallers.biodata_tracking') }}" class="btn btn-light">
                        {{ translate('Reset') }}
                    </a>
                </div>
            </div>
        </form>
    </div>
</div>

{{-- Biodata Table --}}
<div class="card">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table aiz-table mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>{{ translate('Member') }}</th>
                        <th>{{ translate('Gender') }}</th>
                        <th>{{ translate('Phone') }}</th>
                        <th>{{ translate('Religion/Caste') }}</th>
                        <th>{{ translate('Code') }}</th>
                        <th>{{ translate('Package') }}</th>
                        <th>{{ translate('Filled By') }}</th>
                        <th>{{ translate('Date') }}</th>
                        <th class="text-right">{{ translate('Action') }}</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($biodatas as $member)
                        <tr>
                            <td>{{ $loop->iteration + ($biodatas->currentPage() - 1) * $biodatas->perPage() }}</td>
                            <td>
                                <strong>{{ $member->first_name }} {{ $member->last_name }}</strong>
                            </td>
                            <td>
                                @if($member->member)
                                    @if($member->member->gender == 1)
                                        <span class="badge badge-inline badge-soft-primary">{{ translate('Male') }}</span>
                                    @else
                                        <span class="badge badge-inline badge-soft-pink">{{ translate('Female') }}</span>
                                    @endif
                                @else
                                    —
                                @endif
                            </td>
                            <td>{{ $member->phone }}</td>
                            <td>
                                @if($member->spiritual_backgrounds)
                                    <span class="fs-12">
                                        {{ $member->spiritual_backgrounds->religion->name ?? '—' }} / 
                                        {{ $member->spiritual_backgrounds->caste->name ?? '—' }}
                                    </span>
                                @else
                                    <span class="text-muted fs-12">—</span>
                                @endif
                            </td>
                            <td>
                                <span class="badge badge-soft-secondary">{{ $member->code }}</span>
                            </td>
                            <td>
                                @if($member->member && $member->member->package)
                                    <span class="badge badge-soft-success">{{ $member->member->package->name }}</span>
                                @else
                                    <span class="text-muted fs-12">—</span>
                                @endif
                            </td>
                            <td>
                                @if($member->telecaller)
                                    <div class="d-flex align-items-center">
                                        <div class="user-avatar-sm bg-soft-primary mr-2 rounded-circle d-flex align-items-center justify-content-center"
                                            style="width:32px;height:32px;font-weight:bold;font-size:13px;color:#3874ff;">
                                            {{ strtoupper(substr($member->telecaller->first_name, 0, 1)) }}
                                        </div>
                                        <span>{{ $member->telecaller->first_name }} {{ $member->telecaller->last_name }}</span>
                                    </div>
                                @else
                                    <span class="text-muted">—</span>
                                @endif
                            </td>
                            <td>
                                <span class="fs-12 text-muted">
                                    {{ $member->created_at ? $member->created_at->format('d M Y, h:i A') : '—' }}
                                </span>
                            </td>
                            <td class="text-right">
                                <a href="{{ route('members.show', encrypt($member->id)) }}"
                                    class="btn btn-soft-primary btn-icon btn-circle btn-sm"
                                    title="{{ translate('View Profile') }}">
                                    <i class="las la-eye"></i>
                                </a>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="8" class="text-center py-4 text-muted">
                                <i class="las la-folder-open fs-24 d-block mb-2"></i>
                                {{ translate('No biodatas found') }}
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        {{-- Pagination --}}
        @if($biodatas->hasPages())
            <div class="aiz-pagination mt-4">
                {{ $biodatas->appends(request()->all())->links() }}
            </div>
        @endif
    </div>
</div>

@endsection
{{-- Sanket: Admin Biodata Tracking View --}}
