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
        Schema::create('telecaller_coupon_usages', function (Blueprint $table) {
            $table->id();
            $table->integer('telecaller_id');
            $table->integer('user_id'); // Registered member
            $table->string('coupon_code');
            $table->decimal('discount_amount', 10, 2)->default(0);
            $table->decimal('commission_amount', 10, 2)->default(0);
            $table->string('status')->default('applied'); // applied, paid
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('telecaller_coupon_usages');
    }
};
