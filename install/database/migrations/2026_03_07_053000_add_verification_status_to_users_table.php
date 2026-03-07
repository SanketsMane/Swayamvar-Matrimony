<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

// Sanket: Adds verification_status and verification_rejection_reason to track admin decisions
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            // Tracks the lifecycle: pending → approved | rejected | query
            $table->string('verification_status')->nullable()->default(null)->after('verification_info');
            // Admin's message to the user on rejection or query
            $table->text('verification_rejection_reason')->nullable()->after('verification_status');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['verification_status', 'verification_rejection_reason']);
        });
    }
};
