<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;
use App\User;

class Follow extends JsonResource
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
    'followed_user_id' => $this->followed_user_id,
    'user' => User::find($this->user_id),
    'follow' => User::find($this->followed_user_id),
    'created_at' => $this->created_at,
    'updated_at' => $this->updated_at,
];
    }
}
