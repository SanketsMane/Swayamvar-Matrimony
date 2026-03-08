-- Insert the necessary Telecalling permissions
INSERT IGNORE INTO `permissions` (`name`, `guard_name`, `created_at`, `updated_at`) VALUES
('telecalling_dashboard', 'web', NOW(), NOW()),
('manage_telecallers', 'web', NOW(), NOW()),
('lead_upload', 'web', NOW(), NOW()),
('lead_distribution', 'web', NOW(), NOW()),
('active_leads_view', 'web', NOW(), NOW()),
('inactive_leads_view', 'web', NOW(), NOW()),
('call_history', 'web', NOW(), NOW()),
('duplicate_leads', 'web', NOW(), NOW()),
('reassignment', 'web', NOW(), NOW()),
('telecalling_reports', 'web', NOW(), NOW()),
('telecalling_settings', 'web', NOW(), NOW());

-- Map the newly created permissions to the Super Admin role.
-- NOTE: We assume the Super Admin Role has `id` = 1.
-- If your Super Admin role uses a different ID, change the `1` on line 18 before running.
INSERT IGNORE INTO `role_has_permissions` (`permission_id`, `role_id`)
SELECT `id`, 1 FROM `permissions` WHERE `name` IN (
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
    'telecalling_settings'
);
