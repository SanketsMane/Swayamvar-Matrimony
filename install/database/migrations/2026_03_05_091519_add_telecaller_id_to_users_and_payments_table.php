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
        if (!Schema::hasColumn('users', 'telecaller_id')) {
            Schema::table('users', function (Blueprint $table) {
                $table->unsignedBigInteger('telecaller_id')->nullable()->after('fcm_token');
                $table->foreign('telecaller_id')->references('id')->on('users')->onDelete('set null');
            });
        }

        if (!Schema::hasColumn('package_payments', 'telecaller_id')) {
            Schema::table('package_payments', function (Blueprint $table) {
                $table->unsignedBigInteger('telecaller_id')->nullable()->after('package_id');
                $table->foreign('telecaller_id')->references('id')->on('users')->onDelete('set null');
            });
        }
    }

    public function down()
    {
        Schema::table('package_payments', function (Blueprint $table) {
            $table->dropForeign(['telecaller_id']);
            $table->dropColumn('telecaller_id');
        });

        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign(['telecaller_id']);
            $table->dropColumn('telecaller_id');
        });
    }
};
