import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'search_content.dart';
import '../blocs/search_main_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/image_model.dart';
import 'package:Storyteller/src/ui/profile.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:line_icons/line_icons.dart';
import 'dart:async';

class SearchPage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<SearchPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
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
          bloc.fetchPhoto(controller.text);
          bloc.photoFetcherStatusSearch.listen((onData) {
            bloc.fetchPhoto(controller.text);
          });
        }
      },
    );
  }

  void _onRefresh() async {
    // monitor network fetch
    await bloc.fetchPhoto(controller.text);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  refresh() {}

  refreshFilter() {
    setState(() {});
  }

  TextEditingController controller = new TextEditingController();
  bool hasSearchEntry = false;

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Color.fromRGBO(61, 131, 255, 1),
              ),
              child: TextField(
                controller: controller,
                decoration: new InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                  suffixIcon: hasSearchEntry
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            controller.clear();
                            bloc.fetchPhoto(controller.text);
                            setState(
                              () {
                                hasSearchEntry = false;
                              },
                            );
                          },
                        )
                      : SizedBox(),
                  hintText: 'Search...',
                ),
                onChanged: onSearchTextChanged,
              ),
            ),
            actions: [
              hasSearchEntry
                  ? SizedBox()
                  : IconButton(
                      icon: Icon(LineIcons.group),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchContentPage(),
                          ),
                        );
                      },
                    ),
            ],
          ),
          body: buildMyList(),
        ),
        Container(
          height: MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
          ),
        ),
      ],
    );
  }

  Widget buildMyList() {
    final screenSize = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: bloc.allPhotos,
      builder: (context, AsyncSnapshot<ImageModel> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.datas.length == 0) {
            return Center(
              child: Text("No Posts"),
            );
          } else {
            return SmartRefresher(
              enablePullDown: true,
              header: ClassicHeader(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StorytellerProfile(
                                  snapshot.data.data[index].user.data.id,
                                  false,
                                  refresh),
                            ),
                          ),
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 15.0, top: 10.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: new BorderRadius.circular(30.0),
                                child: CachedNetworkImage(
                                  height: kToolbarHeight / 1.1,
                                  width: kToolbarHeight / 1.1,
                                  fit: BoxFit.cover,
                                  placeholder: (c, d) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                      ),
                                    );
                                  },
                                  imageUrl: snapshot
                                      .data.data[index].user.data.avatar,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        snapshot
                                            .data.data[index].user.data.name,
                                        style: TextStyle(
                                          fontFamily: "SFProDisplayMedium",
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2.0,
                                      ),
                                      new Text(
                                        timeago.format(
                                          DateTime.parse(snapshot
                                                  .data.data[index].createdat)
                                              .toLocal(),
                                        ),
                                        style: TextStyle(
                                          fontFamily: "SFProDisplayRegular",
                                          fontSize: 14,
                                          color:
                                              Color.fromRGBO(152, 152, 152, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(30.0),
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
                                (snapshot.data.data[index].like == "true")
                                    ? bloc.unlikepost(
                                        snapshot.data.data[index].id)
                                    : bloc
                                        .likepost(snapshot.data.data[index].id);
                              },
                              child: (snapshot.data.data[index].like == "true")
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
                              snapshot.data.data[index].likecount.toString() +
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
                              snapshot.data.data[index].user.data.name + ':',
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
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }

        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
          ),
        );
      },
    );
  }

  Future onSearchTextChanged(String value) async {
    bloc.fetchPhoto(value);
    setState(() {
      hasSearchEntry = value.isNotEmpty;
    });
  }
}
