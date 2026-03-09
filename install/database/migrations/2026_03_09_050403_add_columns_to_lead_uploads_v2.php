<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('lead_uploads', function (Blueprint $table) {
            if (!Schema::hasColumn('lead_uploads', 'total_rows')) {
                $table->integer('total_rows')->default(0);
            }
            if (!Schema::hasColumn('lead_uploads', 'processed_rows')) {
                $table->integer('processed_rows')->default(0);
            }
        });
    }

    public function down()
    {
        Schema::table('lead_uploads', function (Blueprint $table) {
            $table->dropColumn(['total_rows', 'processed_rows']);
        });
    }
};
