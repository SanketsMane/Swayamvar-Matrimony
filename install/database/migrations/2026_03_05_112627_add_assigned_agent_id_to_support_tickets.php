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
        if (!Schema::hasColumn('support_tickets', 'assigned_agent_id')) {
            Schema::table('support_tickets', function (Blueprint $table) {
                $table->unsignedBigInteger('assigned_agent_id')->nullable()->after('user_id');
                $table->foreign('assigned_agent_id')->references('id')->on('users')->onDelete('set null');
            });
        }
    }

    public function down()
    {
        if (Schema::hasColumn('support_tickets', 'assigned_agent_id')) {
            Schema::table('support_tickets', function (Blueprint $table) {
                $table->dropForeign(['assigned_agent_id']);
                $table->dropColumn('assigned_agent_id');
            });
        }
    }
};
