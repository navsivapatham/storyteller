<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use DB;
use App\User;
use App\Conversation;
use Carbon;

use App\Notifications\NewConversation;

use App\Http\Resources\Conversation as ConversationResource;

class ConversationController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        //  dd($request->has('conversation_to'));
        $user=User::find($request->user()->id);
        $user->updated_at=Carbon\Carbon::now();
        $user->save();
        if ($request->has('conversation_to')) {
            $conversations=Conversation::where("conversation_from", $request->user()->id)->where('conversation_to', '=', $request->conversation_to)->pluck('conversation_to');
            $conversations->push($request->user()->id);
            //dd($conversations);
            $list=Conversation::where([["conversation_to",$request->conversation_to] ,['conversation_from',$request->user()->id]])->orWhere([["conversation_from",$request->conversation_to] ,['conversation_to',$request->user()->id]])->take($request->_limit)->get();

            return ConversationResource::collection($list) ->additional(['user' => User::find($request->conversation_to)]);
        } else {
            $conversations=Conversation::where("conversation_from", $request->user()->id)->pluck('conversation_to');
            $conversations->push($request->user()->id);
            return  ConversationResource::collection(Conversation::orderby("id", "desc")->whereIn("conversation_from", $conversations)->take($request->_limit)->get());
            //  ->additional(['user' => User::find($this->conversation_to)]);
        }
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $user=User::find($request->user()->id);
        $user->updated_at=Carbon\Carbon::now();
        $user->save();
        $post=Conversation::create([
      'conversation_from' => $request->user()->id,
      'conversation_to' => $request->conversation_to,
      'message' => $request->message
      ]);
        $conversationData= new ConversationResource($post);
        $post->to->notify(new NewConversation($conversationData));
        return response()->json($post, 201);
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        //
    }
    public function conversation_list(Request $request)
    {
        $user=User::find($request->user()->id);
        $user->updated_at=Carbon\Carbon::now();
        $user->save();
        $subQuery = "(SELECT MAX(id) id FROM `conversations` where `conversation_from`=".$request->user()->id." or `conversation_to`=".$request->user()->id." GROUP BY `conversation_to`,`conversation_from`) max_date";

        $res = DB::table('conversations')
            ->select('conversations.*')
            ->join(DB::raw($subQuery), function ($join) {
                $join->on('max_date.id', '=', 'conversations.id');
            })
            ->where('conversations.conversation_from', $request->user()->id)
            ->get();
        return  ConversationResource::collection($res)->additional(['user' => User::find($request->user()->id)]);
    }
}
