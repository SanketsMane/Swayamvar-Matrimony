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
        Schema::table('telecaller_details', function (Blueprint $table) {
            $table->string('coupon_code')->nullable()->unique()->after('user_id');
            $table->decimal('discount_percent', 5, 2)->default(0)->after('coupon_code');
            $table->decimal('commission_percent', 5, 2)->default(0)->after('discount_percent');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('telecaller_details', function (Blueprint $table) {
            $table->dropColumn(['coupon_code', 'discount_percent', 'commission_percent']);
        });
    }
};
