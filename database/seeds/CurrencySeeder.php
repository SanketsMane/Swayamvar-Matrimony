<?php

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class CurrencySeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Update Indian Rupee entry (assuming ID 28 based on earlier checks)
        DB::table('currencies')->where('id', 28)->update([
            'name' => 'Indian Rupee',
            'code' => 'INR',
            'symbol' => '₹',
            'exchange_rate' => 1.00000,
            'status' => 1
        ]);

        // Set system default currency
        DB::table('settings')->where('type', 'system_default_currency')->update(['value' => 28]);
    }
}
