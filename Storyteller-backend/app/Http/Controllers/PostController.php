<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Post;
use App\Like;
use App\Follow;
use App\User;
use Storage;
use DB;

use App\Http\Resources\Post as PostResource;
use App\Http\Resources\Like as LikeResource;
use App\Http\Resources\User as UserResource;


use App\Notifications\LikedPhotoNotification;

class PostController extends Controller
{

    /**
     * Display a listing of the resource.
     * Like::where('user_id', $request->user()->id)->where("post_id", $this->id)
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $following = Follow::where("user_id", $request->user()->id)->pluck('followed_user_id');
        $following->push($request->user()->id);
        //  dd($following);
        return  PostResource::collection(Post::orderby("id", "desc")->whereIn("user_id", $following)->take($request->_limit)->get());
    }

    public function me(Request $request)
    {
        //  dd($request->user()->id);
        return  PostResource::collection(Post::where("user_id", $request->user()->id)->orderby("id", "desc")->get());
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
        $request->validate([
            'image' => 'required',
        ]);
        $image = $request->image;  // your base64 encoded
        $image = str_replace('data:image/png;base64,', '', $image);
        $image = str_replace(' ', '+', $image);
        $imageName = str_random(15) . '.' . 'png';
        \File::put(public_path() . '/images' . '/' . $imageName, base64_decode($image));
        $path = Storage::disk('public')->url('/images' . '/' . $imageName);
        $path = str_replace("/storage/", "/", $path);
        $post = Post::firstOrCreate([
            'user_id' => $request->user()->id,
            'image' => $path,
            'description' => $request->description,
        ]);



        return response()->json($post, 201);
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
            return  PostResource::collection(Post::where("user_id", $request->user()->id)->orderby("id", "desc")->get());
        } else {
            return  PostResource::collection(Post::where("user_id", $id)->orderby("id", "desc")->get());
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
        //
    }

    public function search(Request $request)
    {
        if (is_null($request->q)) {
            $posts = Post::orderby("id", "desc")->take($request->_limit)->get();
        } else {
            $posts = DB::table('posts')
                ->where([
                    ['description', 'like', '%' . $request->q . '%'],
                ])
                ->orderby("id", "desc")
                ->take($request->_limit)
                ->get();
        }


        return PostResource::collection($posts);
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(Request $request, $id)
    {
        $post = Post::where("user_id", $request->user()->id)->where("id", $id)->first();
        $post->delete();
        return response()->json(["message" => "Successflly Destroied", "status" => true], 201);
    }

    public function likes(Request $request, $id)
    {
        $like = Like::where('post_id', $id)->pluck('user_id');
        return UserResource::collection(User::orderby("id", "desc")->whereIn('id', $like)->take($request->_limit)->get());
    }

    public function like(Request $request, $id)
    {
        $like = Like::firstOrCreate([
            "user_id" => $request->user()->id,
            "post_id" => $id
        ]);
        $likedata = new LikeResource(Like::find($like->id));
        $like->post->user->notify(new LikedPhotoNotification($likedata));
        return response()->json(["message" => "Successflly Liked", "status" => true], 201);
    }
    public function unlike(Request $request, $id)
    {
        $like = Like::where("user_id", $request->user()->id)->where("post_id", $id)->first();
        $like->delete();
        return response()->json(["message" => "Successflly UnLiked", "status" => true], 201);
    }
}
