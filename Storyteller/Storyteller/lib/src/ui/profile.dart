import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Storyteller/src/models/user_model.dart';
import 'package:Storyteller/src/ui/conversation_send.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'settings.dart';
import 'package:line_icons/line_icons.dart';
import '../blocs/profile_bloc.dart';
import 'globals.dart' as global;
import 'package:connectivity/connectivity.dart';
import 'dart:async';

class StorytellerProfile extends StatefulWidget {
  final int idController;
  final bool searchContentPage;
  final Function() notifyParent;

  StorytellerProfile(
      this.idController, this.searchContentPage, this.notifyParent,
      {Key key})
      : super(key: key);

  @override
  MyTimelinePage createState() => new MyTimelinePage();
}

class MyTimelinePage extends State<StorytellerProfile> {
  int counterbus = 0;
  Color _colorforFollow = Color.fromRGBO(61, 131, 255, 1);
  Color _colorforUnfollow = Color.fromRGBO(231, 76, 60, 1);
  Color blue = Color.fromRGBO(61, 131, 255, 1);
  int likebus = 0;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  bool auto = false;

  @override
  void initState() {
    super.initState();
    if (widget.idController != 0) {
      auto = true;
    }
    check().then(
      (internet) {
        if (internet == false) {
        } else {
          print(global.userId);
          if (widget.searchContentPage == true) {
            global.spin = true;
          } else {
            global.spin = false;
          }
          bloc.fetchUser(widget.idController);
          bloc.fetchUserPhotos(widget.idController);
          bloc.photoFetcherStatus.listen((onData) {
            if (likebus <= 0) {
              setState(() {
                likebus++;
              });
            }

            bloc.fetchUserPhotos(widget.idController);
          });
          bloc.userFetcherStatus.listen(
            (onData) {
              if (counterbus <= 0) {
                if (!mounted) return;
                setState(() {
                  counterbus++;
                });

                bloc.fetchUser(widget.idController);
              }
            },
          );
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
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                elevation: 1.0,
                expandedHeight: kToolbarHeight,
                pinned: true,
                backgroundColor: Colors.white,
                floating: true,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'SFProDisplayRegular',
                    fontSize: 20.0,
                  ),
                ),
                leading: auto ? BackButton() : SizedBox(),
                actions: [
                  (widget.idController == 0 ||
                          widget.idController == global.userId)
                      ? IconButton(
                          icon: Icon(LineIcons.cog),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsForm(),
                              ),
                            );
                          },
                        )
                      : SizedBox(),
                ],
              ),
              StreamBuilder(
                stream: bloc.userDetail,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return buildProfileHeader(
                        context, snapshot, widget.idController);
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
              StreamBuilder(
                stream: bloc.allPhotos,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.data.length == 0) {
                      return SliverToBoxAdapter(
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text("No Posts"),
                          ),
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.0,
                                      right: 10.0,
                                      bottom: 15.0,
                                      top: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      new GestureDetector(
                                        onTap: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  StorytellerProfile(
                                                      snapshot.data.data[index]
                                                          .user.data.id,
                                                      false,
                                                      refresh),
                                            ),
                                          ),
                                        },
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0),
                                              child: CachedNetworkImage(
                                                height: kToolbarHeight / 1.1,
                                                width: kToolbarHeight / 1.1,
                                                fit: BoxFit.cover,
                                                placeholder: (c, d) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                    ),
                                                  );
                                                },
                                                imageUrl: snapshot
                                                    .data
                                                    .data[index]
                                                    .user
                                                    .data
                                                    .avatar,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    new Text(
                                                      snapshot.data.data[index]
                                                          .user.data.name,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "SFProDisplayMedium",
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 2.0,
                                                    ),
                                                    new Text(
                                                      timeago.format(
                                                        DateTime.parse(snapshot
                                                                .data
                                                                .data[index]
                                                                .createdat)
                                                            .toLocal(),
                                                      ),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "SFProDisplayRegular",
                                                        fontSize: 14,
                                                        color: Color.fromRGBO(
                                                            152, 152, 152, 1),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: ClipRRect(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                    child: CachedNetworkImage(
                                      height: screenSize.width - 20.0,
                                      width: screenSize.width,
                                      placeholder: (c, d) {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.0,
                                          ),
                                        );
                                      },
                                      fit: BoxFit.cover,
                                      imageUrl: snapshot.data.data[index].image,
                                    ),
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 15.0,
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            likebus = 0;
                                          });

                                          (snapshot.data.data[index].like ==
                                                  "true")
                                              ? bloc.unlikepost(
                                                  snapshot.data.data[index].id)
                                              : bloc.likepost(
                                                  snapshot.data.data[index].id);
                                        },
                                        child:
                                            (snapshot.data.data[index].like ==
                                                    "true")
                                                ? Icon(
                                                    LineIcons.heart,
                                                    color: Colors.red,
                                                  )
                                                : Icon(
                                                    LineIcons.heart_o,
                                                  ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        snapshot.data.data[index].likecount
                                                .toString() +
                                            ' ' +
                                            'Likes',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: "SFProDisplayMedium",
                                          fontSize: 14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                new Padding(
                                  padding: EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 10.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        snapshot.data.data[index].user.data
                                                .name +
                                            ':',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: "SFProDisplayMedium",
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Text(
                                        snapshot.data.data[index].description,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: "SFProDisplayRegular",
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                              ],
                            );
                          },
                          childCount: snapshot.data.data.length,
                        ),
                      );
                    }
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
          ),
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

  Widget buildProfileHeader(
      context, AsyncSnapshot<UserModel> user, int userowner) {
    final screenSize = MediaQuery.of(context).size;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: new Align(
              alignment: Alignment.center,
              child: Container(
                height: kToolbarHeight * 1.80,
                width: kToolbarHeight * 1.80,
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: user.data.user.avatar,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          new Container(
            child: new Text(
              user.data.user.name,
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontFamily: 'SFProDisplayBold',
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          new Container(
            child: new Text(
              user.data.user.email,
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontFamily: 'SFProDisplayRegular',
                  fontSize: 14.0,
                  color: Color.fromRGBO(152, 152, 152, 1)),
            ),
          ),
          new Column(
            children: <Widget>[
              (user.data.user.bio == null)
                  ? Container()
                  : Container(
                      margin:
                          EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Theme.of(context).cardColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: new Text(
                          user.data.user.bio,
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontFamily: 'SFProDisplaySemiBold',
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          new Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              new Container(
                width: screenSize.width,
                margin: EdgeInsets.only(top: 10.0),
                child: new Row(
                  children: <Widget>[
                    Container(
                      width: screenSize.width / 3,
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            user.data.user.follower.toString(),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontFamily: 'SFProDisplaySemiBold',
                              fontSize: 15.0,
                            ),
                          ),
                          new Text(
                            "Followers",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontFamily: 'SFProDisplayRegular',
                                fontSize: 13.0,
                                color: Color.fromRGBO(152, 152, 152, 1)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenSize.width / 3,
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            user.data.user.following.toString(),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontFamily: 'SFProDisplaySemiBold',
                              fontSize: 15.0,
                            ),
                          ),
                          new Text(
                            "Following",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontFamily: 'SFProDisplayRegular',
                                fontSize: 13.0,
                                color: Color.fromRGBO(152, 152, 152, 1)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenSize.width / 3,
                      child: new Column(
                        children: <Widget>[
                          new Text(
                            user.data.user.photocount.toString(),
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontFamily: 'SFProDisplaySemiBold',
                              fontSize: 15.0,
                            ),
                          ),
                          new Text(
                            "Posts",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontFamily: 'SFProDisplayRegular',
                                fontSize: 13.0,
                                color: Color.fromRGBO(152, 152, 152, 1)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (userowner == 0 || userowner == global.userId)
                  ? Container()
                  : new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                          height: kToolbarHeight / 1.6,
                          minWidth: MediaQuery.of(context).size.width / 4,
                          child: RaisedButton(
                            color: (user.data.user.follow == "true")
                                ? _colorforUnfollow
                                : _colorforFollow,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0)),
                            child: (user.data.user.follow == "true")
                                ? Text(
                                    "Unfollow",
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontFamily: 'SFProDisplayRegular'),
                                  )
                                : Text(
                                    "Follow",
                                    style: new TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.white,
                                        fontFamily: 'SFProDisplayRegular'),
                                  ),
                            onPressed: () {
                              setState(() {
                                counterbus = 0;
                              });
                              (user.data.user.follow == "true")
                                  ? check().then(
                                      (internet) async {
                                        if (internet == false) {
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    new Text('Are you sure?'),
                                                content: new Text(
                                                    "You won't be following this person anymore!"),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                actions: <Widget>[
                                                  new FlatButton(
                                                    child: new Text("No"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  new FlatButton(
                                                    child: new Text("Yes"),
                                                    onPressed: () async {
                                                      await bloc.unfollowuser(
                                                          userowner);
                                                      widget.notifyParent();
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                    )
                                  : check().then(
                                      (internet) async {
                                        if (internet == false) {
                                        } else {
                                          bloc.followuser(userowner);
                                        }
                                      },
                                    );
                              widget.notifyParent();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        ButtonTheme(
                          height: kToolbarHeight / 1.6,
                          minWidth: MediaQuery.of(context).size.width / 4,
                          child: RaisedButton(
                            color: Color.fromRGBO(61, 131, 255, 1),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0)),
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
                                      ConversationSendForm(userowner),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
