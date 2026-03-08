<?php
use Spatie\Permission\Models\Permission;
use Spatie\Permission\Models\Role;
use App\Models\User;

$permissions = [
    'telecalling_dashboard',
    'manage_telecallers',
    'lead_upload',
    'lead_distribution',
    'active_leads_view',
    'inactive_leads_view',
    'call_history',
    'duplicate_leads',
    'reassignment',
    'telecalling_reports',
    'telecalling_settings',
];

foreach ($permissions as $perm) {
    Permission::firstOrCreate(['name' => $perm, 'guard_name' => 'web']);
}

$role = Role::where('name', 'Super Admin')->first() ?? Role::first();
if ($role) {
    $role->givePermissionTo($permissions);
    echo "Permissions given to role: " . $role->name . "\n";
}

$admin = User::where('user_type', 'admin')->first();
if ($admin) {
    if ($role) {
        $admin->assignRole($role);
    } else {
        $admin->givePermissionTo($permissions);
    }
    echo "Permissions added to admin: " . $admin->email . "\n";
}
echo "Done.\n";
