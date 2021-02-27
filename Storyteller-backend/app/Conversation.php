<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Conversation extends Model
{
    protected $fillable = [
  'conversation_from', 'conversation_to','message','created_at','updated_at'
];
    protected $table = 'conversations';

    public function from()
    {
        return $this->hasOne('App\User', 'id', 'conversation_from');
    }
    public function to()
    {
        return $this->hasOne('App\User', 'id', 'conversation_to');
    }
}
