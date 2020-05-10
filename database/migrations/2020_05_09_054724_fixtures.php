<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class Fixtures extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
       Schema::create('fixtures', function (Blueprint $table) {
            $table->id();
            $table->integer('team1_id');
            $table->integer('team2_id');
            $table->dateTime('date_time',0);
            $table->string('venue_location','100');
            $table->integer('completed')->defualt('0');
             $table->integer('winning_team_id')->defulat('0');
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
      schema::dropIfExists('fixtures');
    }
}
