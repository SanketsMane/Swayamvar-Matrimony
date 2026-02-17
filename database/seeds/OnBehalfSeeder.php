<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class OnBehalfSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        if (DB::table('on_behalves')->count() == 0) {
            $data = [
                ['name' => 'Self'],
                ['name' => 'Daughter'],
                ['name' => 'Son'],
                ['name' => 'Sister'],
                ['name' => 'Brother'],
                ['name' => 'Friend'],
                ['name' => 'Mother'],
                ['name' => 'Father'],
            ];

            DB::table('on_behalves')->insert($data);
        }
    }
}
