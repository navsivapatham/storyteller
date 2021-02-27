<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;
use App\User;
use App\Post;

class Like extends JsonResource
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
  'post_id' => $this->post_id,
  'user' => User::find($this->user_id),
  'post' => Post::find($this->post_id),
  'created_at' => $this->created_at,
  'updated_at' => $this->updated_at,
];
    }
}
