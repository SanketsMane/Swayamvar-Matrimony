<?php

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class SuperAdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $user = User::where('email', 'contactsanket1@gmail.com')->first();
        if (!$user) {
            $user = new User;
            $user->email = 'contactsanket1@gmail.com';
        }
        $user->first_name = 'Sanket';
        $user->last_name = 'Mane';
        $user->password = Hash::make('Sanket@3030');
        $user->user_type = 'admin';
        $user->save();

        // Assign role if possible (assuming role 1 is Super Admin based on local check)
        // DB::table('role_user')->updateOrInsert(['user_id' => $user->id], ['role_id' => 1]);
    }
}
