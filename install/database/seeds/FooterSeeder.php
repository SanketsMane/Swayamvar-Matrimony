<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class FooterSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Update or insert footer settings
        // Assuming header_logo ID 14 is the one we want to use, based on prior checks.
        // If it changes, update here.
        
        $settings = [
            'footer_logo' => '14',
            'about_us_description' => 'Swayamvar is a premium matrimonial platform designed to bring hearts together. Our mission is to help you find your perfect life partner with ease and trust.',
            'footer_address' => 'Mumbai, India',
            'footer_website' => 'http://127.0.0.1:8000',
            'footer_email' => 'visionitinfra01@gmail.com', // Using the SMTP email for consistency
            'footer_phones' => json_encode(['+01 112 352 566']), // Same as helpline, encoded as JSON for the loop
           // 'footer_copyright_text' => 'Swayamvar - Developed by Sanket Mane', // Already set, leaving it or updating if needed. Let's update to be sure.
        ];

        foreach ($settings as $key => $value) {
            $exists = DB::table('settings')->where('type', $key)->exists();
            if ($exists) {
                DB::table('settings')->where('type', $key)->update(['value' => $value]);
            } else {
                DB::table('settings')->insert(['type' => $key, 'value' => $value]);
            }
        }
    }
}
