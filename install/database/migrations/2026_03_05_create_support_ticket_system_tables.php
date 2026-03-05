<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

// Sanket: Creates the support ticket system tables from scratch on production
return new class extends Migration
{
    public function up(): void
    {
        // 1. Create support_ticket_categories if missing
        if (!Schema::hasTable('support_ticket_categories')) {
            Schema::create('support_ticket_categories', function (Blueprint $table) {
                $table->id();
                $table->string('name');
                $table->timestamps();
            });

            // Seed default categories
            \DB::table('support_ticket_categories')->insert([
                ['name' => 'Technical Issue', 'created_at' => now(), 'updated_at' => now()],
                ['name' => 'Account Problem', 'created_at' => now(), 'updated_at' => now()],
                ['name' => 'Payment Issue', 'created_at' => now(), 'updated_at' => now()],
                ['name' => 'Profile Concerns', 'created_at' => now(), 'updated_at' => now()],
                ['name' => 'General Inquiry', 'created_at' => now(), 'updated_at' => now()],
            ]);
        }

        // 2. Create support_tickets if missing
        if (!Schema::hasTable('support_tickets')) {
            Schema::create('support_tickets', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('user_id');
                $table->unsignedBigInteger('category_id')->nullable();
                $table->string('subject');
                $table->text('description');
                // Status: open, replied, closed
                $table->enum('status', ['open', 'replied', 'closed'])->default('open');
                $table->string('priority')->default('medium'); // low, medium, high
                // Telecaller assigned to handle this ticket
                $table->unsignedBigInteger('assigned_agent_id')->nullable();
                $table->timestamps();

                $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
                $table->foreign('category_id')->references('id')->on('support_ticket_categories')->onDelete('set null');
                $table->foreign('assigned_agent_id')->references('id')->on('users')->onDelete('set null');
            });
        } else {
            // Table exists — ensure assigned_agent_id column is present
            if (!Schema::hasColumn('support_tickets', 'assigned_agent_id')) {
                Schema::table('support_tickets', function (Blueprint $table) {
                    $table->unsignedBigInteger('assigned_agent_id')->nullable()->after('priority');
                    $table->foreign('assigned_agent_id')->references('id')->on('users')->onDelete('set null');
                });
            }
        }

        // 3. Create support_ticket_replies if missing
        if (!Schema::hasTable('support_ticket_replies')) {
            Schema::create('support_ticket_replies', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('support_ticket_id');
                $table->unsignedBigInteger('user_id'); // Who replied (admin/agent/member)
                $table->text('reply');
                $table->timestamps();

                $table->foreign('support_ticket_id')->references('id')->on('support_tickets')->onDelete('cascade');
                $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            });
        }
    }

    public function down(): void
    {
        // Drop in reverse dependency order
        Schema::dropIfExists('support_ticket_replies');
        Schema::dropIfExists('support_tickets');
        Schema::dropIfExists('support_ticket_categories');
    }
};
