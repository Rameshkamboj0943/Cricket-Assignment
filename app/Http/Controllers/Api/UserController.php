<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\User;
use Auth;


class UserController extends Controller
{
	
    //
    public function index()
    {
    	return response()->json(['users'=>User::all()],200);
    }
    public function login(Request $request)
    {
    	$email=$request->email;
    	$password=md5($request->password);
    	$user=User::where('email',$email)->where('password',$password)->first();
    	if($user){
        $token=Hash::make($password);
        $user->api_token=$token;
        $user->save();
        return response()->json(['token'=>$token],200);
        }
        return response()->json(['Message'=>'Wrong Username/Passsord'],403);



    }
}
