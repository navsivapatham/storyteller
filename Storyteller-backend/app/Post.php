<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    protected $fillable = [
        'image', 'user_id', 'description', 'likes'
    ];
    protected $table = 'posts';


    public function user()
    {
        return $this->hasOne('App\User', 'id', 'user_id');
    }
}
