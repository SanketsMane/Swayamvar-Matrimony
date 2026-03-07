<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('telecalling_campaigns', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->text('description')->nullable();
            $table->string('status')->default('active'); // active, archived
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::create('lead_uploads', function (Blueprint $table) {
            $table->id();
            $table->string('file_name');
            $table->integer('total_leads')->default(0);
            $table->integer('valid_leads')->default(0);
            $table->integer('duplicate_leads')->default(0);
            $table->integer('invalid_leads')->default(0);
            $table->unsignedBigInteger('campaign_id')->nullable();
            $table->unsignedBigInteger('user_id'); // uploader
            $table->timestamps();

            $table->foreign('campaign_id')->references('id')->on('telecalling_campaigns')->onDelete('set null');
            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });

        Schema::create('telecaller_details', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->string('pincode')->nullable();
            $table->string('department')->nullable();
            $table->string('state')->nullable();
            $table->string('city')->nullable();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });

        Schema::create('active_leads', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('mobile')->index();
            $table->string('email')->nullable();
            $table->string('city')->nullable();
            $table->string('pincode')->nullable();
            $table->string('source')->nullable();
            $table->string('business_type')->nullable();
            $table->text('notes')->nullable();
            $table->json('custom_fields')->nullable();
            $table->unsignedBigInteger('campaign_id')->nullable();
            $table->unsignedBigInteger('upload_id')->nullable();
            $table->unsignedBigInteger('assigned_to')->nullable();
            $table->string('status')->default('New'); // New, Called, Interested, Not Interested, Invalid, Switched Off, Follow-up, Converted
            $table->timestamp('last_call_at')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->foreign('campaign_id')->references('id')->on('telecalling_campaigns')->onDelete('set null');
            $table->foreign('upload_id')->references('id')->on('lead_uploads')->onDelete('set null');
            $table->foreign('assigned_to')->references('id')->on('users')->onDelete('set null');
        });

        Schema::create('inactive_leads', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('mobile')->index();
            $table->string('email')->nullable();
            $table->string('city')->nullable();
            $table->string('pincode')->nullable();
            $table->string('source')->nullable();
            $table->string('business_type')->nullable();
            $table->text('notes')->nullable();
            $table->json('custom_fields')->nullable();
            $table->unsignedBigInteger('campaign_id')->nullable();
            $table->unsignedBigInteger('upload_id')->nullable();
            $table->string('reason')->nullable(); // Invalid, Not Interested, etc.
            $table->unsignedBigInteger('marked_inactive_by')->nullable();
            $table->unsignedBigInteger('previous_agent_id')->nullable();
            $table->timestamps();
            $table->softDeletes();

            $table->foreign('campaign_id')->references('id')->on('telecalling_campaigns')->onDelete('set null');
            $table->foreign('upload_id')->references('id')->on('lead_uploads')->onDelete('set null');
            $table->foreign('marked_inactive_by')->references('id')->on('users')->onDelete('set null');
            $table->foreign('previous_agent_id')->references('id')->on('users')->onDelete('set null');
        });

        Schema::create('telecalling_call_logs', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('lead_id');
            $table->string('lead_type'); // active_lead, inactive_lead
            $table->unsignedBigInteger('agent_id');
            $table->string('status');
            $table->text('notes')->nullable();
            $table->integer('duration')->nullable(); // in seconds
            $table->string('outcome')->nullable();
            $table->timestamp('call_time');
            $table->timestamps();

            $table->foreign('agent_id')->references('id')->on('users')->onDelete('cascade');
        });

        Schema::create('telecalling_followups', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('lead_id');
            $table->unsignedBigInteger('agent_id');
            $table->timestamp('followup_date');
            $table->text('notes')->nullable();
            $table->string('status')->default('pending'); // pending, completed, cancelled
            $table->timestamps();

            $table->foreign('lead_id')->references('id')->on('active_leads')->onDelete('cascade');
            $table->foreign('agent_id')->references('id')->on('users')->onDelete('cascade');
        });

        Schema::create('duplicate_leads', function (Blueprint $table) {
            $table->id();
            $table->string('mobile');
            $table->string('name')->nullable();
            $table->json('data')->nullable(); // original data from upload
            $table->unsignedBigInteger('upload_id');
            $table->timestamps();

            $table->foreign('upload_id')->references('id')->on('lead_uploads')->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::dropIfExists('duplicate_leads');
        Schema::dropIfExists('telecalling_followups');
        Schema::dropIfExists('telecalling_call_logs');
        Schema::dropIfExists('inactive_leads');
        Schema::dropIfExists('active_leads');
        Schema::dropIfExists('telecaller_details');
        Schema::dropIfExists('lead_uploads');
        Schema::dropIfExists('telecalling_campaigns');
    }
};
