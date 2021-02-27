<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Follow extends Model
{
    protected $fillable = [
        'user_id', 'followed_user_id', 'created_at', 'updated_at'
    ];
    protected $table = 'follows';

    public function user()
    {
        return $this->hasOne('App\User', 'id', 'user_id');
    }
    public function follow()
    {
        return $this->hasOne('App\User', 'id', 'followed_user_id');
    }
}
