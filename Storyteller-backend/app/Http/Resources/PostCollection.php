<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\ResourceCollection;

class PostCollection extends ResourceCollection
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
          'user_id' => $this->user_id,
          'image' => $this->image,
          'description' => $this->description,
          'likes' => $this->likes,
          'created_at' => $this->created_at,
          'updated_at' => $this->updated_at,
      ];
    }
}
