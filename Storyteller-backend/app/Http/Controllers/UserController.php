<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Storage;
use DB;

use App\Http\Resources\User as UserResource;
use App\Http\Resources\Follow as FollowResource;

use App\User;
use App\Follow;

use App\Notifications\StartedToFollowNotification;

class UserController extends Controller
{

    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */



    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request, $id)
    {
        if ($id == 0) {
            return new UserResource(User::findOrFail($request->user()->id));
        } else {
            return new UserResource(User::findOrFail($id));
        }
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //    dd($request->all());
        $request->validate([
            'email' => 'required|email|unique:users,id,' . $request->user()->id . '|max:255',
            'name' => 'required',
        ]);
        $user = User::find($request->user()->id);
        $user->email = $request->email;
        $user->name = $request->name;
        $user->bio = $request->bio;
        if ($request->avatar != "") {
            $image = $request->avatar;  // your base64 encoded
            $image = str_replace('data:image/png;base64,', '', $image);
            $image = str_replace(' ', '+', $image);
            $imageName = str_random(15) . '.' . 'png';
            \File::put(public_path() . '/avatar' . '/' . $imageName, base64_decode($image));
            $path = Storage::disk('public')->url('/avatar' . '/' . $imageName);
            $path = str_replace("/storage/", "/", $path);
            $user->avatar = $path;
        }


        $user->save();

        return response()->json($user, 201);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }

    public function me(Request $request)
    {
        return new UserResource(User::find($request->user()->id));
    }

    public function find(Request $request)
    {
        if (is_null($request->q)) {
            $users = User::where('id', '!=', $request->user()->id)->get();
        } else {
            $users = DB::table('users')
                ->where([
                    ['name', 'like', '%' . $request->q . '%'],
                    ['id', '!=', $request->user()->id],
                ])
                ->orWhere([
                    ['email', 'like', '%' . $request->q . '%'],
                    ['id', '!=', $request->user()->id],
                ])
                ->get();
        }


        return UserResource::collection($users);
    }

    public function follow(Request $request, $id)
    {
        if ($request->user()->id != $id) {
            $follow = Follow::firstOrCreate([
                "user_id" => $request->user()->id,
                "followed_user_id" => $id
            ]);
            $followdata = new FollowResource(Follow::find($follow->id));
            $follow->follow->notify(new StartedToFollowNotification($followdata));
            return response()->json(["message" => "Successflly followed", "status" => true], 201);
        }
        return response()->json(["message" => "You cannot follow your self", "status" => false], 201);
    }
    public function unfollow(Request $request, $id)
    {
        $follow = Follow::where("user_id", $request->user()->id)->where("followed_user_id", $id)->first();
        $follow->delete();
        return response()->json(["message" => "Successflly unFollowed", "status" => true], 201);
    }
    public function notifications(Request $request)
    {
        $user = User::find($request->user()->id);
        return response()->json($user->unreadNotifications, 201);
    }
    public function read_notifications(Request $request)
    {
        $user = User::find($request->user()->id);
        $user->unreadNotifications->markAsRead();
        return response()->json(["message" => "Successflly read", "status" => true], 201);
    }
}
