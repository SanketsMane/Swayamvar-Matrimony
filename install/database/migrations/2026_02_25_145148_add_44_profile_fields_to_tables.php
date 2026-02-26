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
        Schema::table('users', function (Blueprint $table) {
            $table->string('middle_name')->nullable();
            $table->string('gov_id_type')->nullable();
            $table->string('gov_id_number')->nullable();
            $table->string('mobile2')->nullable();
            $table->string('id_proof')->nullable();
        });

        Schema::table('families', function (Blueprint $table) {
            $table->boolean('father_alive')->default(true);
            $table->boolean('mother_alive')->default(true);
            $table->integer('no_of_brothers')->nullable();
            $table->integer('married_brothers')->nullable();
            $table->integer('no_of_sisters')->nullable();
            $table->integer('married_sisters')->nullable();
            $table->text('property_details')->nullable();
        });

        Schema::table('spiritual_backgrounds', function (Blueprint $table) {
            $table->boolean('manglik')->default(false);
            $table->boolean('intercaste_accepted')->default(false);
        });

        Schema::table('partner_expectations', function (Blueprint $table) {
            $table->boolean('intercaste_accepted')->default(false);
            $table->boolean('divorce_accepted')->default(false);
        });

        Schema::table('careers', function (Blueprint $table) {
            $table->text('occupation_details')->nullable();
        });

        Schema::table('physical_attributes', function (Blueprint $table) {
            $table->text('disability_details')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['middle_name', 'gov_id_type', 'gov_id_number', 'mobile2', 'id_proof']);
        });

        Schema::table('families', function (Blueprint $table) {
            $table->dropColumn(['father_alive', 'mother_alive', 'no_of_brothers', 'married_brothers', 'no_of_sisters', 'married_sisters', 'property_details']);
        });

        Schema::table('spiritual_backgrounds', function (Blueprint $table) {
            $table->dropColumn(['manglik', 'intercaste_accepted']);
        });

        Schema::table('partner_expectations', function (Blueprint $table) {
            $table->dropColumn(['intercaste_accepted', 'divorce_accepted']);
        });

        Schema::table('careers', function (Blueprint $table) {
            $table->dropColumn('occupation_details');
        });

        Schema::table('physical_attributes', function (Blueprint $table) {
            $table->dropColumn('disability_details');
        });
    }
};
