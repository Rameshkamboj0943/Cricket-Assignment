<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class Players extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('players', function (Blueprint $table) {
            $table->id();
            $table->foreign('team_id')->references('id')->on('teams');
            $table->string('firstName','100');
            $table->string('lastName','100');
            $table->string('imageUri','100');
            $table->integer('Playerjerseynumber');
            $table->string('country','100');
            $table->string('matches','100');
            $table->string('run','50');
            $table->string('highestscores','10');
            $table->string('fifties','10');
            $table->string('hundreds','10');
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
        Schema::dropIfExists('players');
    }
}
