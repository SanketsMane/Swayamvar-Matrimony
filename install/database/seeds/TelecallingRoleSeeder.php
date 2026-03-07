<?php

use Illuminate\Database\Seeder;

class TelecallingRoleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Permissions
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

        foreach ($permissions as $permission) {
            \Spatie\Permission\Models\Permission::updateOrCreate(
                ['name' => $permission, 'guard_name' => 'web'],
                ['parent' => 'telecalling']
            );
        }

        // Create Telecalling Agent Role
        $telecallerRole = \Spatie\Permission\Models\Role::findOrCreate('Telecalling Agent', 'web');
        $telecallerRole->syncPermissions([
            'telecalling_dashboard',
            'active_leads_view',
            'inactive_leads_view',
            'call_history'
        ]);

        // Assign all to Super Admin
        $superAdmin = \Spatie\Permission\Models\Role::where('name', 'Super Admin')->first();
        if ($superAdmin) {
            $superAdmin->givePermissionTo($permissions);
        }
    }
}
