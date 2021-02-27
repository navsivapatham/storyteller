<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;
use App\User;

class Conversation extends JsonResource
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
  'conversation_from' => $this->conversation_from,
  'conversation_to' => $this->conversation_to,
  'from' => User::find($this->conversation_from),
  'to' => User::find($this->conversation_to),
  'message' =>$this->message,
  'created_at' => $this->created_at,
  'updated_at' => $this->updated_at,
];
    }
}
