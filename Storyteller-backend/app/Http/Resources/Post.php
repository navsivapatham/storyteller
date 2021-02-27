<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;
use App\Http\Resources\User as UserResource;
use App\User;
use App\Like;

class Post extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        return [
        'id' => $this->id,
        'user_id' => $this->user_id,
        'image' => $this->image,
        'description' => $this->description,
        'likes' => $this->likes,
        'user' => new UserResource(User::find($this->user_id)),
        'like' => $this->when(Like::where('user_id', $request->user()->id)->where("post_id", $this->id)->exists(), 'true'),
        'like_count' => Like::where("post_id", $this->id)->count(),
        'created_at' => $this->created_at,
        'updated_at' => $this->updated_at,
    ];
    }
}
