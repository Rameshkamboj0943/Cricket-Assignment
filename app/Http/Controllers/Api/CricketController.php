<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use App\Team;
use App\Point;
use App\Player;
use App\Match;
use Auth;
class CricketController extends Controller
{
	
    //
    public function index()
    {
    	return response()->json(['teams'=>Team::all()],200);
    }
    public function getplayer()
    {
         $players = DB::table('players')
            ->join('teams as teamA', 'teamA.id', '=', 'players.team_id')
            ->select('players.*','teamA.name as teamName','teamA.id as teamid')
            ->get();
      return response()->json(['players'=>$players,'teams'=>Team::all()],200);
        
    }
    public function getteamplayer($id)
    {
     $players = DB::table('players')
            ->join('teams as teamA', 'teamA.id', '=', 'players.team_id')
            ->select('players.*','teamA.name as teamName','teamA.id as teamid')
            ->where('players.team_id',$id)
            ->get();
      return response()->json(['players'=>$players,'teams'=>Team::all()],200);
          
    }
    public function destroy($id)
    {
        $team=Team::find($id)->delete();
        return response()->json(['teams'=>Team::all()],200);
        
    }
    public function deleteplayer($id)
    {

        $team=Player::find($id)->delete();
        return response()->json(['teams'=>Player::all()],200);
        
    }
    public function getmatch()
    {
        $matches = DB::table('fixtures')
            ->join('teams as teamA', 'teamA.id', '=', 'fixtures.team1_id')
            ->join('teams as teamB', 'teamB.id', '=', 'fixtures.team2_id')
            ->select('fixtures.id','fixtures.venue_location as location','fixtures.completed as completed','fixtures.date_time as matchdate', 'teamA.name as teamA','teamA.logoUri as teamALogo','teamA.id as teamAID', 'teamB.name as teamB','teamB.id as teamBID','teamB.logoUri as teamBLogo')
            ->get();
     return response()->json(['matches'=>$matches,'teams'=>Team::all()],200);
               
        
    }
    public function getmatchlist()
    {
     $matches = DB::table('fixtures')
            ->join('teams as teamA', 'teamA.id', '=', 'fixtures.team1_id')
            ->join('teams as teamB', 'teamB.id', '=', 'fixtures.team2_id')
            ->join('teams as winnerTeam', 'winnerTeam.id', '=', 'fixtures.winning_team_id')
            ->select('fixtures.id','fixtures.venue_location as location','fixtures.completed as completed','fixtures.date_time as matchdate', 'teamA.name as teamA','teamA.logoUri as teamALogo','teamA.id as teamAID', 'teamB.name as teamB','teamB.id as teamBID','teamB.logoUri as teamBLogo','winnerTeam.name as winnerteam')
            ->get();
     return response()->json(['matches'=>$matches,'teams'=>Team::all()],200);
               
           
    }
    public function update(Request $request)
    {
         if($request->file('photo'))
         {
          $ext=$request->photo->extension();
          $logo=$request->photo->storeAs('images',Str::random(18).".{$ext}",'public');
           
         }else
         {
            $logo=$request->photo;    
         }
         $team=Team::find($request->id);
         $team->name=$request->name;
         $team->logoUri=$logo;
         $team->clubstate=$request->clubstate;
         $team->save();
         return response()->json(['teams'=>Team::all()],200);
       
        

    }
    public function updateplayer(Request $request)
    {

          if($request->file('photo'))
         {
             $ext=$request->photo->extension();
            $logo=$request->photo->storeAs('player',Str::random(18).".{$ext}",'public');
        }else
        {
          $logo=$request->photo;    
            
        }
         $team=Player::find($request->id);
         $team->team_id=$request->team_id;
         $team->firstname=$request->firstname;
         $team->lastname=$request->lastname;
         $team->Playerjerseynumber=$request->playerjerseynumber;
         $team->country=$request->country;
         $team->matches=$request->matches;
         $team->run=$request->run;
        
         $team->imageUri=$logo;
         $team->highestscores=$request->highestscores;
         $team->fifties=$request->fifties;
         $team->hundreds=$request->hundreds;
         $team->save();
         return response()->json(['teams'=>Player::all()],200);


    }
    /********* function for Update Match Status****/
    public function updatematchstatus(Request $request)
    {
        $match=Match::find($request->id);
        $data=[$match->team1_id,$match->team2_id];

        $match->completed=$request->completed;
        $match->winning_team_id=$request->winner_team;

        $match->save();
       
        for($i=0;$i<count($data);$i++)
        {
             $points=new Point();
          if($data[$i]==$request->winner_team)
        {
            $points->matches_win=1;
            $points->points =2;
            $points->matches_lost=0;
        }else
        {
            $points->matches_win=0;
            $points->points =0;
            $points->matches_lost=1;
       
            
        }
         $points->team_id=$data[$i];
         $points->save();


        }
        //Update Points Table As Per Fixtures//
        

      
        return response()->json(['teams'=>Player::all()],200);
        


    }
    public function addteam(Request $request)
    {
        
         $ext=$request->photo->extension();
         $logo=$request->photo->storeAs('images',Str::random(18).".{$ext}",'public');
         $team=new Team();
         $team->name=$request->name;
         $team->logoUri=$logo;
         $team->clubstate=$request->clubstate;
         $team->save();
         return response()->json(['teams'=>Team::all()],200);
       

        
    }
    public function addfixtures(Request $request)
    {
         $team=new Match();
         $team->team1_id=$request->teamA;
         $team->team2_id=$request->teamB;
         $team->date_time=$request->date;
         $team->venue_location=$request->location;
         $team->completed='0';
         $team->winning_team_id='0';
         $team->save();
         return response()->json(['teams'=>Team::all()],200);

    }
    public function addplayer(Request $request)
    {
         $ext=$request->photo->extension();
         $logo=$request->photo->storeAs('player',Str::random(18).".{$ext}",'public');
         $team=new Player();
         $team->team_id=$request->team_id;
         $team->firstname=$request->firstname;
         $team->lastname=$request->lastname;
         $team->Playerjerseynumber=$request->playerjerseynumber;
         $team->country=$request->country;
         $team->matches=$request->matches;
         $team->run=$request->run;
        
         $team->imageUri=$logo;
         $team->highestscores=$request->highestscores;
         $team->fifties=$request->fifties;
         $team->hundreds=$request->hundreds;
         $team->save();
         return response()->json(['teams'=>Player::all()],200);

    }
    //Get Points Team wise
    public function getpoint()
    {
        $matches = DB::table('points')
            ->join('teams', 'teams.id', '=', 'points.team_id')
           
            ->select('teams.name as teamA',DB::raw("SUM(points.matches_win) as matchwin"),DB::raw("SUM(points.matches_lost) as matchlost"),DB::raw("SUM(points.points) as totalpoint"))
            ->groupBy('teams.id')
            ->get();
     return response()->json(['points'=>$matches],200);


    }
    
}
