<?php
use App\Models\User;
use App\Models\Member;
use App\Models\MemberLanguage;
use App\Models\Address;
use App\Models\Upload;
use Illuminate\Support\Facades\Hash;

require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$emails = ['rahul@example.com', 'snehal@example.com', 'prathamesh@example.com', 'priyanka@example.com', 'sanket_m@example.com', 'pratiksha@example.com', 'akshay@example.com', 'rutuja@example.com', 'vishal@example.com', 'tanvi@example.com'];

foreach ($emails as $email) {
    // Search including trashed users
    $user = User::withTrashed()->where('email', $email)->first();
    if ($user) {
        echo "Cleaning up user: " . $email . " (ID: " . $user->id . ")\n";
        // Delete child rows first (some might be soft-deleted too, so we use forceDelete or raw query)
        \DB::table('addresses')->where('user_id', $user->id)->delete();
        \DB::table('members')->where('user_id', $user->id)->delete();
        \DB::table('uploads')->where('user_id', $user->id)->delete();
        $user->forceDelete();
    }
}

// Ensure Marathi language exists
$marathi = MemberLanguage::firstOrCreate(['name' => 'Marathi']);

$profiles = [
    ['first_name' => 'Rahul', 'last_name' => 'Deshmukh', 'gender' => 'male', 'city_id' => 2474, 'image' => 'marathi_male_1.png', 'email' => 'rahul@example.com'],
    ['first_name' => 'Snehal', 'last_name' => 'Patil', 'gender' => 'female', 'city_id' => 2478, 'image' => 'marathi_female_1.png', 'email' => 'snehal@example.com'],
    ['first_name' => 'Prathamesh', 'last_name' => 'Kulkarni', 'gender' => 'male', 'city_id' => 2482, 'image' => 'marathi_male_2.png', 'email' => 'prathamesh@example.com'],
    ['first_name' => 'Priyanka', 'last_name' => 'More', 'gender' => 'female', 'city_id' => 2478, 'image' => 'marathi_female_2.png', 'email' => 'priyanka@example.com'],
    ['first_name' => 'Sanket', 'last_name' => 'Joshi', 'gender' => 'male', 'city_id' => 2480, 'image' => 'marathi_male_3.png', 'email' => 'sanket_m@example.com'],
    ['first_name' => 'Pratiksha', 'last_name' => 'Shinde', 'gender' => 'female', 'city_id' => 2474, 'image' => 'marathi_female_3.png', 'email' => 'pratiksha@example.com'],
    ['first_name' => 'Akshay', 'last_name' => 'Gaware', 'gender' => 'male', 'city_id' => 2478, 'image' => 'marathi_male_4.png', 'email' => 'akshay@example.com'],
    ['first_name' => 'Rutuja', 'last_name' => 'Jadhav', 'gender' => 'female', 'city_id' => 2482, 'image' => 'marathi_female_2.png', 'email' => 'rutuja@example.com'],
    ['first_name' => 'Vishal', 'last_name' => 'Pawar', 'gender' => 'male', 'city_id' => 2478, 'image' => 'marathi_male_5.png', 'email' => 'vishal@example.com'],
    ['first_name' => 'Tanvi', 'last_name' => 'Kadam', 'gender' => 'female', 'city_id' => 2480, 'image' => 'marathi_female_5.png', 'email' => 'tanvi@example.com'],
];

foreach ($profiles as $profile) {
    // 1. Create User
    $user = User::create([
        'first_name' => $profile['first_name'],
        'last_name' => $profile['last_name'],
        'name' => $profile['first_name'] . ' ' . $profile['last_name'],
        'email' => $profile['email'],
        'password' => Hash::make('password'),
        'user_type' => 'member',
        'membership' => 1,
        'approved' => 1,
        'email_verified_at' => now(),
    ]);

    // 2. Create Upload record
    $upload = Upload::create([
        'file_original_name' => $profile['image'],
        'file_name' => 'all/' . $profile['image'],
        'user_id' => $user->id,
        'extension' => 'png',
        'type' => 'image',
        'file_size' => 102400,
    ]);

    // Update user photo
    $user->update(['photo' => $upload->id]);

    // 3. Create Member
    Member::create([
        'user_id' => $user->id,
        'gender' => $profile['gender'],
        'birthday' => '1995-01-01',
        'mothere_tongue' => $marathi->id,
        'current_package_id' => 1,
        'remaining_interest' => 10,
        'remaining_contact_view' => 10,
        'remaining_photo_gallery' => 10,
    ]);

    // 4. Create Address
    Address::create([
        'user_id' => $user->id,
        'type' => 'present',
        'country_id' => 101,
        'state_id' => 22,
        'city_id' => $profile['city_id'],
    ]);

    echo "Successfully Re-inserted: " . $user->first_name . " " . $user->last_name . "\n";
}
