<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ActiveLead;
use App\Models\TelecallingCampaign;
use Log;

class MetaLeadController extends Controller
{
    /**
     * Handle Meta Webhook for Lead Ads [Sanket]
     */
    public function webhook(Request $request)
    {
        // Meta Webhook Verification
        if ($request->has('hub_mode') && $request->has('hub_verify_token')) {
            if ($request->hub_verify_token === env('META_WEBHOOK_VERIFY_TOKEN')) {
                return $request->hub_challenge;
            }
        }

        // Process Lead Data
        $data = $request->all();
        Log::info('Meta Webhook received: ', $data);

        // Implementation for Meta Lead Ads logic
        // This usually involves fetching lead details via Meta Graph API using the leadgen_id
        
        if (isset($data['entry'][0]['changes'][0]['value']['leadgen_id'])) {
            $leadgen_id = $data['entry'][0]['changes'][0]['value']['leadgen_id'];
            $this->fetchAndStoreMetaLead($leadgen_id);
        }

        return response()->json(['status' => 'success']);
    }

    protected function fetchAndStoreMetaLead($leadgen_id)
    {
        // Note: Real implementation require a Page Access Token and Meta SDK/Guzzle call
        // Using sample/mock logic for now as requested
        
        Log::info("Fetching lead data for ID: " . $leadgen_id);

        // Mock data for demonstration
        $name = "Meta Lead " . $leadgen_id;
        $email = "lead_" . $leadgen_id . "@example.com";
        $mobile = "1234567890"; // In reality, fetch from Graph API

        $campaign = TelecallingCampaign::where('source', 'Meta')->where('status', 'active')->first();

        ActiveLead::create([
            'name' => $name,
            'mobile' => $mobile,
            'email' => $email,
            'source' => 'Meta Ads',
            'campaign_id' => $campaign ? $campaign->id : null,
            'status' => 'Unassigned',
        ]);
        
        Log::info("Meta Lead stored: " . $email);
    }
}
