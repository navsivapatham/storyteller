import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Storyteller/src/blocs/conversation_list_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:Storyteller/src/models/conversation_model.dart';
import 'dart:async';
import 'conversation_send.dart';

class ConversationListForm extends StatefulWidget {
  final int toUsernameController;
  ConversationListForm(this.toUsernameController);

  @override
  StoryTellerConversationList createState() =>
      new StoryTellerConversationList(toUsernameController);
}

class StoryTellerConversationList extends State<ConversationListForm> {
  TextEditingController messageController = TextEditingController();

  final int toUsernameController;

  StoryTellerConversationList(this.toUsernameController);
  StreamSubscription connectivitySubscription;
  Timer timer;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    const oneSec = const Duration(seconds: 1);
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {});

    timer = Timer.periodic(
      oneSec,
      (timer) {
        connectivitySubscription.resume();
        check().then(
          (internet) {
            if (internet == false) {
            } else {
              blocList.fetchUserConversationList(toUsernameController);
              blocList.dispose();
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();

    blocList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildList(),
          Container(
            height: MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          elevation: 1.0,
          expandedHeight: kToolbarHeight,
          pinned: true,
          floating: true,
          title: Text(
            'Conversations',
            style: TextStyle(
              fontFamily: 'SFProDisplayRegular',
              fontSize: 20.0,
            ),
          ),
          centerTitle: true,
        ),
        StreamBuilder(
          stream: blocList.conversationFetcher,
          builder: (context, AsyncSnapshot<ConversationModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.datas.length == 0) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: 50.0,
                    child: Center(
                      child: Text("No Conversations"),
                    ),
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return new Padding(
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Material(
                            color: Theme.of(context).cardColor,
                            borderRadius: new BorderRadius.circular(20.0),
                            child: InkWell(
                              borderRadius: new BorderRadius.circular(20.0),
                              onTap: () {
                                navigateToConversation(
                                    snapshot.data.datas[index].to.user.id);
                              },
                              child: new ListTile(
                                leading: ClipRRect(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  child: CachedNetworkImage(
                                    height: kToolbarHeight / 1.1,
                                    width: kToolbarHeight / 1.1,
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot
                                        .data.datas[index].to.user.avatar,
                                  ),
                                ),
                                title: new Text(
                                    snapshot.data.datas[index].to.user.name),
                                subtitle: new Text(
                                  snapshot.data.datas[index].message,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: snapshot.data.data.length,
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return SliverToBoxAdapter(
                child: Container(
                  height: 50.0,
                  child: Center(
                    child: Text(snapshot.error.toString()),
                  ),
                ),
              );
            }

            return SliverToBoxAdapter(
              child: Container(
                height: 50.0,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void navigateToConversation(int id) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ConversationSendForm(id)));
  }
}
