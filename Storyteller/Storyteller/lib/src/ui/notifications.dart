import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Storyteller/src/ui/profile.dart';
import '../blocs/notification_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:line_icons/line_icons.dart';
import 'conversation_send.dart';
import 'dart:async';

class StoryTellerNotification extends StatefulWidget {
  @override
  PagewiseGridViewExample createState() => PagewiseGridViewExample();
}

class PagewiseGridViewExample extends State<StoryTellerNotification> {
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
    check().then(
      (internet) {
        if (internet == false) {
        } else {
          bloc.fetchAllNotifications();
          bloc.userFetcherStatus.listen((onData) {
            bloc.fetchAllNotifications();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  refresh() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildList(),
          Container(
            height: MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
            ),
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
          actions: [
            IconButton(
              icon: Icon(LineIcons.trash),
              onPressed: () {
                bloc.readNotifications();
              },
            )
          ],
          centerTitle: true,
          title: Text(
            'Notifications',
            style: TextStyle(
              fontFamily: 'SFProDisplayRegular',
              fontSize: 20.0,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        StreamBuilder(
          stream: bloc.allNotifications,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.datas.length == 0) {
                return SliverToBoxAdapter(
                  child: Container(
                    height: 50.0,
                    child: Center(
                      child: Text("No Notifications"),
                    ),
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      dynamic notificationdata =
                          json.decode(snapshot.data.datas[index].data);
                      switch (snapshot.data.datas[index].type) {
                        case "App\\Notifications\\StartedToFollowNotification":
                          return InkWell(
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: new BorderRadius.circular(30.0),
                                child: CachedNetworkImage(
                                  height: kToolbarHeight / 1.1,
                                  width: kToolbarHeight / 1.1,
                                  fit: BoxFit.cover,
                                  imageUrl: (notificationdata["user"]
                                      ["avatar"]),
                                ),
                              ),
                              title: new Text(notificationdata["user"]["name"]),
                              subtitle: new Text('Started following you'),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StorytellerProfile(
                                      notificationdata["user"]["id"],
                                      false,
                                      refresh),
                                ),
                              );
                            },
                          );

                          break;
                        case "App\\Notifications\\LikedPhotoNotification":
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: new BorderRadius.circular(30.0),
                              child: CachedNetworkImage(
                                height: kToolbarHeight / 1.1,
                                width: kToolbarHeight / 1.1,
                                fit: BoxFit.cover,
                                imageUrl: (notificationdata["user"]["avatar"]),
                              ),
                            ),
                            title: new Text(notificationdata["user"]["name"]),
                            subtitle: new Text('Liked your Post'),
                            trailing: ClipRRect(
                              borderRadius: new BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                height: kToolbarHeight / 1.2,
                                width: kToolbarHeight / 1.2,
                                fit: BoxFit.cover,
                                imageUrl: notificationdata["post"]["image"],
                              ),
                            ),
                          );

                          break;
                        case "App\\Notifications\\NewConversation":
                          return InkWell(
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: new BorderRadius.circular(30.0),
                                child: CachedNetworkImage(
                                  height: kToolbarHeight / 1.1,
                                  width: kToolbarHeight / 1.1,
                                  fit: BoxFit.cover,
                                  imageUrl: (notificationdata["from"]
                                      ["avatar"]),
                                ),
                              ),
                              title: new Text(notificationdata["from"]["name"]),
                              subtitle: new Text('Send you a message'),
                              trailing: ButtonTheme(
                                height: kToolbarHeight / 1.6,
                                minWidth: MediaQuery.of(context).size.width / 4,
                                child: RaisedButton(
                                  color: Color.fromRGBO(61, 131, 255, 1),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0)),
                                  child: new Text(
                                    "Message",
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontFamily: 'SFProDisplayRegular'),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ConversationSendForm(
                                                notificationdata["from"]["id"]),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StorytellerProfile(
                                      notificationdata["from"]["id"],
                                      false,
                                      refresh),
                                ),
                              );
                            },
                          );

                          break;
                      }

                      return Container();
                    },
                    childCount: snapshot.data.datas.length,
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
}
