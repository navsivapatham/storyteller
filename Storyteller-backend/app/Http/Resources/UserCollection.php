<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\ResourceCollection;

class UserCollection extends ResourceCollection
{
    /**
     * Transform the resource collection into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array
     */
    public function toArray($request)
    {
        return [
    'id' => $this->id,
    'name' => $this->name,
    'email' => $this->email,
    'bio' => $this->bio,
    'avatar' => $this->avatar,
    'photo_count'=>Post::where("user_id", $this->id)->count(),
    'follower'=>Follow::where("followed_user_id", $this->id)->count(),
    'following'=>Follow::where("user_id", $this->id)->count(),
    'created_at' => $this->created_at,
    'updated_at' => $this->updated_at,
];
    }
}
