<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});
Route::post('/login','Api\UserController@login')->name('login');
Route::resource('/users','Api\UserController');
//Route::get('/teams','Api\CricketController@index');
Route::post('/teams/addteam','Api\CricketController@addteam');
Route::post('/match/addfixtures','Api\CricketController@addfixtures');
Route::post('/players/addplayer','Api\CricketController@addplayer');
Route::resource('/teams','Api\CricketController');
Route::get('/players/getplayer','Api\CricketController@getplayer');
Route::get('players/getteamplayer/{id}','Api\CricketController@getteamplayer');
Route::get('points/getpoint','Api\CricketController@getpoint');
Route::get('matches/getmatch','Api\CricketController@getmatch');
Route::get('matches/getmatchlist','Api\CricketController@getmatchlist');
Route::post('teams/update','Api\CricketController@update');
Route::post('players/updateplayer','Api\CricketController@updateplayer');
Route::post('match/updatefixtures','Api\CricketController@updatematchstatus');
Route::get('players/delete/{id}','Api\CricketController@deleteplayer');