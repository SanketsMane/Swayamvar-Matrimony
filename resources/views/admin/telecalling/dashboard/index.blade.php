@extends('admin.layouts.app')

@section('content')

<div class="aiz-titlebar text-left mt-2 mb-3">
    <div class="row align-items-center">
        <div class="col-md-6">
            <h1 class="h3">{{translate('Telecaller Dashboard')}}</h1>
        </div>
        <div class="col-md-6 text-right">
            {{-- Sanket: Fill Biodata CTA [primary action for telecaller] --}}
            <a href="{{ route('telecalling.fill_biodata') }}"
               class="btn btn-primary btn-lg px-5"
               style="border-radius:12px;font-weight:800;letter-spacing:1px;">
                <i class="las la-user-plus mr-2 fs-16"></i>
                {{ translate('Fill Biodata') }}
            </a>
        </div>
    </div>
</div>

<div class="row gutters-10">
    <div class="col-md-3">
        <div class="bg-grad-1 text-white rounded-lg mb-4 overflow-hidden">
            <div class="px-3 pt-3">
                <div class="opacity-50">
                    <span class="fs-12 d-block">{{ translate('Total') }}</span>
                    {{ translate('Assigned Leads') }}
                </div>
                <div class="h3 fw-700 mb-3">{{ $data['total_assigned'] }}</div>
            </div>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
                <path fill="rgba(255,255,255,0.3)" fill-opacity="1" d="M0,128L34.3,112C68.6,96,137,64,206,96C274.3,128,343,224,411,250.7C480,277,549,235,617,213.3C685.7,192,754,192,823,181.3C891.4,171,960,149,1029,117.3C1097.1,85,1166,43,1234,58.7C1302.9,75,1371,149,1406,186.7L1440,224L1440,320L1405.7,320C1371.4,320,1303,320,1234,320C1165.7,320,1097,320,1029,320C960,320,891,320,823,320C754.3,320,686,320,617,320C548.6,320,480,320,411,320C342.9,320,274,320,206,320C137.1,320,69,320,34,320L0,320Z"></path>
            </svg>
        </div>
    </div>
    <div class="col-md-3">
        <div class="bg-grad-2 text-white rounded-lg mb-4 overflow-hidden">
            <div class="px-3 pt-3">
                <div class="opacity-50">
                    <span class="fs-12 d-block">{{ translate('Pending') }}</span>
                    {{ translate('Calls') }}
                </div>
                <div class="h3 fw-700 mb-3">{{ $data['pending_calls'] }}</div>
            </div>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
                <path fill="rgba(255,255,255,0.3)" fill-opacity="1" d="M0,128L34.3,112C68.6,96,137,64,206,96C274.3,128,343,224,411,250.7C480,277,549,235,617,213.3C685.7,192,754,192,823,181.3C891.4,171,960,149,1029,117.3C1097.1,85,1166,43,1234,58.7C1302.9,75,1371,149,1406,186.7L1440,224L1440,320L1405.7,320C1371.4,320,1303,320,1234,320C1165.7,320,1097,320,1029,320C960,320,891,320,823,320C754.3,320,686,320,617,320C548.6,320,480,320,411,320C342.9,320,274,320,206,320C137.1,320,69,320,34,320L0,320Z"></path>
            </svg>
        </div>
    </div>
    <div class="col-md-3">
        <div class="bg-grad-3 text-white rounded-lg mb-4 overflow-hidden">
            <div class="px-3 pt-3">
                <div class="opacity-50">
                    <span class="fs-12 d-block">{{ translate('Total') }}</span>
                    {{ translate('Calls Done') }}
                </div>
                <div class="h3 fw-700 mb-3">{{ $data['completed_calls'] }}</div>
            </div>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
                <path fill="rgba(255,255,255,0.3)" fill-opacity="1" d="M0,128L34.3,112C68.6,96,137,64,206,96C274.3,128,343,224,411,250.7C480,277,549,235,617,213.3C685.7,192,754,192,823,181.3C891.4,171,960,149,1029,117.3C1097.1,85,1166,43,1234,58.7C1302.9,75,1371,149,1406,186.7L1440,224L1440,320L1405.7,320C1371.4,320,1303,320,1234,320C1165.7,320,1097,320,1029,320C960,320,891,320,823,320C754.3,320,686,320,617,320C548.6,320,480,320,411,320C342.9,320,274,320,206,320C137.1,320,69,320,34,320L0,320Z"></path>
            </svg>
        </div>
    </div>
    <div class="col-md-3">
        <div class="bg-grad-4 text-white rounded-lg mb-4 overflow-hidden">
            <div class="px-3 pt-3">
                <div class="opacity-50">
                    <span class="fs-12 d-block">{{ translate('Today') }}</span>
                    {{ translate('Followups') }}
                </div>
                <div class="h3 fw-700 mb-3">{{ $data['today_followups'] }}</div>
            </div>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
                <path fill="rgba(255,255,255,0.3)" fill-opacity="1" d="M0,128L34.3,112C68.6,96,137,64,206,96C274.3,128,343,224,411,250.7C480,277,549,235,617,213.3C685.7,192,754,192,823,181.3C891.4,171,960,149,1029,117.3C1097.1,85,1166,43,1234,58.7C1302.9,75,1371,149,1406,186.7L1440,224L1440,320L1405.7,320C1371.4,320,1303,320,1234,320C1165.7,320,1097,320,1029,320C960,320,891,320,823,320C754.3,320,686,320,617,320C548.6,320,480,320,411,320C342.9,320,274,320,206,320C137.1,320,69,320,34,320L0,320Z"></path>
            </svg>
        </div>
    </div>
</div>
<div class="row gutters-10 mt-2">
    <!-- Agent Coupon & Commission Info [Sanket] -->
    <div class="col-md-4">
        <div class="card bg-soft-info mb-4">
            <div class="card-body">
                <div class="d-flex align-items-center mb-3">
                    <div class="icon-shape icon-md bg-info text-white rounded-circle mr-3">
                        <i class="las la-ticket-alt"></i>
                    </div>
                    <div>
                        <h6 class="mb-0 fs-14">{{translate('My Coupon Code')}}</h6>
                        <div class="fs-18 fw-700 text-info" id="agent_coupon">{{ $data['coupon_code'] ?? 'None' }}</div>
                    </div>
                </div>
                <div class="d-flex justify-content-between align-items-center">
                    <span class="fs-12">{{translate('Commission Rate')}}: <strong>{{ $data['commission_percent'] ?? 0 }}%</strong></span>
                    @if($data['coupon_code'])
                        <button class="btn btn-sm btn-info" onclick="copyReferralLink()">
                            <i class="las la-copy mr-1"></i>{{translate('Copy Referral Link')}}
                        </button>
                    @endif
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card bg-soft-success mb-4">
            <div class="card-body">
                <div class="d-flex align-items-center">
                    <div class="icon-shape icon-md bg-success text-white rounded-circle mr-3">
                        <i class="las la-hand-holding-usd"></i>
                    </div>
                    <div>
                        <h6 class="mb-0 fs-14">{{translate('Total Commission Earned')}}</h6>
                        <div class="fs-24 fw-700 text-success">{{ format_price($data['total_commission']) }}</div>
                    </div>
                </div>
                <div class="mt-3 text-right">
                    <a href="{{ route('telecalling.my_commissions') }}" class="btn btn-sm btn-link font-weight-bold text-success">{{translate('View Details')}} <i class="las la-arrow-right"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row gutters-10">
    <div class="col-md-8">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Recent Assigned Leads')}}</h5>
                <a href="{{ route('telecalling.assigned_leads') }}" class="btn btn-link">{{translate('View All')}}</a>
            </div>
            <div class="card-body">
                <table class="table aiz-table mb-0">
                    <thead>
                        <tr>
                            <th>{{translate('Name')}}</th>
                            <th>{{translate('Phone')}}</th>
                            <th>{{translate('Status')}}</th>
                            <th class="text-right">{{translate('Action')}}</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($recent_leads as $lead)
                            <tr>
                                <td>{{$lead->name}}</td>
                                <td>{{$lead->mobile}}</td>
                                <td><span class="badge badge-inline badge-info">{{$lead->status}}</span></td>
                                <td class="text-right">
                                    <a class="btn btn-soft-primary btn-icon btn-circle btn-sm" href="{{ route('telecalling.assigned_leads') }}?id={{$lead->id}}" title="{{ translate('Take Action') }}">
                                        <i class="las la-phone"></i>
                                    </a>
                                </td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <!-- Followups Today [Sanket] -->
         <div class="card bg-soft-warning mb-3">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('Today\'s Follow-ups')}}</h5>
            </div>
            <div class="card-body">
                <ul class="list-group list-group-flush">
                    @forelse($data['today_followups_list'] as $followup)
                        <li class="list-group-item bg-transparent">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <strong>{{$followup->lead->name ?? ''}}</strong><br>
                                    <small class="text-muted">{{$followup->followup_date->format('H:i')}}</small>
                                </div>
                                <a href="{{ route('telecalling.assigned_leads') }}?id={{$followup->lead_id}}" class="btn btn-sm btn-primary btn-icon btn-circle">
                                    <i class="las la-phone"></i>
                                </a>
                            </div>
                        </li>
                    @empty
                        <li class="list-group-item bg-transparent text-center text-muted">
                            {{translate('No follow-ups for today')}}
                        </li>
                    @endforelse
                </ul>
            </div>
         </div>

         <div class="card">
            <div class="card-header">
                <h5 class="mb-0 h6">{{translate('My Performance')}}</h5>
            </div>
            <div class="card-body">
                <canvas id="performanceChart" height="200"></canvas>
            </div>
         </div>
    </div>
</div>

@endsection

@section('script')
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script type="text/javascript">
    function copyReferralLink() {
        var copyText = "{{ url('/register') }}?referral_code=" + "{{ $data['coupon_code'] }}";
        var tempInput = document.createElement("input");
        tempInput.value = copyText;
        document.body.appendChild(tempInput);
        tempInput.select();
        document.execCommand("copy");
        document.body.removeChild(tempInput);
        AIZ.plugins.notify('success', '{{ translate("Referral link copied to clipboard") }}');
    }

    // Chart JS for Performance [Sanket]
    document.addEventListener("DOMContentLoaded", function () {
        var ctx = document.getElementById('performanceChart').getContext('2d');
        var performanceChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: {!! $data['chart_dates'] !!},
                datasets: [{
                    label: '{{ translate("Calls Made") }}',
                    data: {!! $data['chart_calls'] !!},
                    backgroundColor: 'rgba(56, 116, 255, 0.1)',
                    borderColor: 'rgba(56, 116, 255, 1)',
                    borderWidth: 2,
                    tension: 0.3,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 1
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    }
                }
            }
        });
    });
</script>
@endsection
