<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PackageSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Check if packages already exist to prevent duplicates
        if (DB::table('packages')->count() == 0 || DB::table('packages')->count() == 1) {
            
            DB::table('packages')->where('id', '!=', 1)->delete(); 

            $packages = [
                [
                    'name' => 'Silver',
                    'price' => 1000,
                    'validity' => 30,
                    'express_interest' => 10,
                    'photo_gallery' => 1,
                    'contact' => 5,
                    'profile_image_view' => 1,
                    'gallery_image_view' => 1,
                    'auto_profile_match' => 0,
                    'active' => 1,
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
                [
                    'name' => 'Gold',
                    'price' => 2500,
                    'validity' => 90,
                    'express_interest' => 50,
                    'photo_gallery' => 1,
                    'contact' => 20,
                    'profile_image_view' => 1,
                    'gallery_image_view' => 1,
                    'auto_profile_match' => 1,
                    'active' => 1,
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
                [
                    'name' => 'Platinum',
                    'price' => 5000,
                    'validity' => 180,
                    'express_interest' => 9999, // Unlimited represented as high number
                    'photo_gallery' => 1,
                    'contact' => 50,
                    'profile_image_view' => 1,
                    'gallery_image_view' => 1,
                    'auto_profile_match' => 1,
                    'active' => 1,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]
            ];

            DB::table('packages')->insert($packages);
        }
    }
}
