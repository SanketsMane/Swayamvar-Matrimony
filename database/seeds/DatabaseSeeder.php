<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     *
     * @return void
     */
    public function run()
    {
        $this->call(OnBehalfSeeder::class);
        $this->call(ReligionSeeder::class);
        $this->call(PackageSeeder::class);
        $this->call(FooterSeeder::class);
        $this->call(CurrencySeeder::class);
        $this->call(SuperAdminSeeder::class);
    }
}
