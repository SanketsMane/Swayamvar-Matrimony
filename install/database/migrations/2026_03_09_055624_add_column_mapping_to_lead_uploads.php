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
        Schema::table('lead_uploads', function (Blueprint $table) {
            if (!Schema::hasColumn('lead_uploads', 'column_mapping')) {
                $table->json('column_mapping')->nullable()->after('campaign_id');
            }
            if (!Schema::hasColumn('lead_uploads', 'status')) {
                $table->string('status')->default('pending')->after('column_mapping');
            }
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('lead_uploads', function (Blueprint $table) {
            $table->dropColumn(['column_mapping', 'status']);
        });
    }
};
