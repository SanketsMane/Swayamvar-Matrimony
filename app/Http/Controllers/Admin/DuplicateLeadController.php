<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\DuplicateLead;
use App\Models\TelecallingCampaign;
use App\Models\ActiveLead;
use DB;

class DuplicateLeadController extends Controller
{
    public function __construct()
    {
        $this->middleware(['permission:duplicate_leads']);
    }

    public function index(Request $request)
    {
        $sort_search = $request->search;
        $date_range = $request->date_range;
        
        $leads = DuplicateLead::latest();

        if ($sort_search) {
            $leads = $leads->where(function($query) use ($sort_search) {
                $query->where('name', 'like', '%'.$sort_search.'%')
                      ->orWhere('mobile', 'like', '%'.$sort_search.'%');
            });
        }

        if ($date_range) {
            $dates = explode(' to ', $date_range);
            if (count($dates) == 2) {
                $leads = $leads->whereBetween('created_at', [$dates[0].' 00:00:00', $dates[1].' 23:59:59']);
            }
        }

        $leads = $leads->paginate(15);
        $campaigns = TelecallingCampaign::where('status', 'active')->get();

        return view('admin.telecalling.duplicate_leads.index', compact('leads', 'sort_search', 'date_range', 'campaigns'));
    }

    public function bulk_action(Request $request)
    {
        $action = $request->action;
        $lead_ids = $request->lead_ids; // array of IDs

        if (!$lead_ids && $action != 'flush_all') {
            flash(translate('No leads selected'))->error();
            return back();
        }

        $query = DuplicateLead::query();
        if (is_array($lead_ids)) {
            $query->whereIn('id', $lead_ids);
        }

        if ($action == 'delete') {
            $query->delete();
            flash(translate('Selected duplicate leads removed'))->success();
        } 
        elseif ($action == 'flush_all') {
            DuplicateLead::truncate();
            flash(translate('All duplicate leads flushed'))->success();
        }
        elseif ($action == 'push_to_campaign') {
            $campaign_id = $request->campaign_id;
            if (!$campaign_id) {
                flash(translate('Please select a campaign'))->error();
                return back();
            }

            $duplicates = $query->get();
            $count = 0;

            DB::transaction(function () use ($duplicates, $campaign_id, &$count) {
                foreach ($duplicates as $duplicate) {
                    $data = $duplicate->data ?? [];
                    
                    ActiveLead::create([
                        'name' => $duplicate->name,
                        'mobile' => $duplicate->mobile,
                        'email' => $data['email'] ?? null,
                        'city' => $data['city'] ?? null,
                        'pincode' => $data['pincode'] ?? null,
                        'source' => $data['source'] ?? 'Restored Duplicate',
                        'business_type' => $data['business_type'] ?? null,
                        'campaign_id' => $campaign_id,
                        'status' => 'New',
                        'upload_id' => $duplicate->upload_id,
                    ]);

                    $duplicate->delete();
                    $count++;
                }
            });

            flash(translate($count . ' leads pushed to campaign successfully'))->success();
        }

        return back();
    }

    public function export(Request $request)
    {
        $sort_search = $request->search;
        $date_range = $request->date_range;
        
        $leads = DuplicateLead::latest();

        if ($sort_search) {
            $leads = $leads->where(function($query) use ($sort_search) {
                $query->where('name', 'like', '%'.$sort_search.'%')
                      ->orWhere('mobile', 'like', '%'.$sort_search.'%');
            });
        }

        if ($date_range) {
            $dates = explode(' to ', $date_range);
            if (count($dates) == 2) {
                $leads = $leads->whereBetween('created_at', [$dates[0].' 00:00:00', $dates[1].' 23:59:59']);
            }
        }

        $filename = "duplicate_leads_" . date('Ymd_His') . ".csv";
        
        // Use a temporary file to build the CSV
        $tempFile = tempnam(sys_get_temp_dir(), 'csv');
        $handle = fopen($tempFile, 'w');

        // Headers
        fputcsv($handle, ['Name', 'Mobile', 'Email', 'City', 'Pincode', 'Source', 'Detected At']);

        $leads->chunk(100, function($chunk) use ($handle) {
            foreach ($chunk as $lead) {
                $data = $lead->data ?? [];
                fputcsv($handle, [
                    $lead->name,
                    $lead->mobile,
                    $data['email'] ?? '',
                    $data['city'] ?? '',
                    $data['pincode'] ?? '',
                    $data['source'] ?? '',
                    $lead->created_at->format('Y-m-d H:i')
                ]);
            }
        });

        fclose($handle);

        return response()->download($tempFile, $filename)->deleteFileAfterSend(true);
    }

    public function destroy($id)
    {
        DuplicateLead::destroy($id);
        flash(translate('Duplicate lead record removed'))->success();
        return back();
    }
}
