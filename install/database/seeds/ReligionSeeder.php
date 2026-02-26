<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ReligionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        if (DB::table('religions')->count() == 0) {
            $data = [
                ['name' => 'Hindu'],
                ['name' => 'Muslim'],
                ['name' => 'Christian'],
                ['name' => 'Sikh'],
                ['name' => 'Parsi'],
                ['name' => 'Jain'],
                ['name' => 'Buddhist'],
                ['name' => 'Jewish'],
                ['name' => 'No Religion'],
                ['name' => 'Spiritual'],
                ['name' => 'Other'],
            ];

            DB::table('religions')->insert($data);
        }
    }
}
