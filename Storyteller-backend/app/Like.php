<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Like extends Model
{
    protected $fillable = [
  'user_id', 'post_id'
];
    protected $table = 'likes';

    public function user()
    {
        return $this->hasOne('App\User', 'id', 'user_id');
    }
    public function post()
    {
        return $this->hasOne('App\Post', 'id', 'post_id');
    }
}
