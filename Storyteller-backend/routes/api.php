<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:api')->get('/user', function (Request $request) {
    return $request->user();
});
Route::post('/signup', 'HomeController@signup')->name('signup');
Route::post('/posts/search', 'PostController@search')->middleware('auth:api')->name('posts.search');
Route::delete('/posts/destroy/{id}', 'PostController@destroy')->middleware('auth:api')->name('posts.destroy');
Route::get('/posts/likes/{id}', 'PostController@likes')->middleware('auth:api')->name('posts.likes');
Route::post('/posts/like/{id}', 'PostController@like')->middleware('auth:api')->name('posts.like');
Route::delete('/posts/unlike/{id}', 'PostController@unlike')->middleware('auth:api')->name('posts.unlike');
Route::resource('posts', 'PostController')->middleware('auth:api');
Route::get('/posts/me', 'PostController@me')->middleware('auth:api')->name('posts.me');
Route::get('/users/me', 'UserController@me')->middleware('auth:api')->name('users.me');
Route::post('/users/find', 'UserController@find')->middleware('auth:api')->name('users.find');
Route::post('/users/follow/{id}', 'UserController@follow')->middleware('auth:api')->name('users.follow');
Route::delete('/users/unfollow/{id}', 'UserController@unfollow')->middleware('auth:api')->name('users.unfollow');
Route::get('/users/notifications', 'UserController@notifications')->middleware('auth:api')->name('users.notifications');
Route::post('/users/read_notifications', 'UserController@read_notifications')->middleware('auth:api')->name('users.read_notifications');
Route::resource('users', 'UserController')->middleware('auth:api');
Route::post('forgot/password', 'HomeController@reset_password')->name('forgot.password');
Route::get('/conversations/list', 'ConversationController@conversation_list')->middleware('auth:api')->name('conversations.list');
Route::resource('conversations', 'ConversationController')->middleware('auth:api');
