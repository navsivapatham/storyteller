import 'package:flutter/material.dart';
import '../blocs/nav_bloc.dart';
import 'package:Storyteller/src/ui/add_photo.dart';
import 'package:Storyteller/src/ui/search.dart';
import 'package:Storyteller/src/ui/newsfeed.dart';
import 'package:Storyteller/src/ui/notifications.dart';
import 'package:Storyteller/src/ui/profile.dart';
import 'package:line_icons/line_icons.dart';
import 'globals.dart' as global;
import '../blocs/profile_bloc.dart';

class StoryTellerBottom extends StatefulWidget {
  @override
  MyBottomNavigationBar createState() => MyBottomNavigationBar();
}

class MyBottomNavigationBar extends State<StoryTellerBottom> {
  BottomNavBarBloc _bottomNavBarBloc;
  bool user = true;

  @override
  void initState() {
    super.initState();
    bloc.fetchUser(0);
    bloc.userDetail.listen(
      (data) {
        if (data != null) {
          if (user == true) {
            print(data.user.id);
            global.userId = data.user.id;
            user = false;
          }
        }
      },
    );
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  void dispose() {
    _bottomNavBarBloc.close();
    bloc.dispose();
    super.dispose();
  }

  refresh() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<NavBarItem>(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          switch (snapshot.data) {
            case NavBarItem.HOME:
              return PhotoFeed();
            case NavBarItem.SEARCH:
              return SearchPage();
            case NavBarItem.ADD:
              return PhotoForm();
            case NavBarItem.ALERT:
              return StoryTellerNotification();
            case NavBarItem.PROFILE:
              return StorytellerProfile(0, false, refresh);
          }

          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          );
        },
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return BottomNavigationBar(
            fixedColor: Color.fromRGBO(61, 131, 255, 1),
            unselectedItemColor: Color.fromRGBO(152, 152, 152, 1),
            currentIndex: snapshot.data.index,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _bottomNavBarBloc.pickItem,
            items: [
              BottomNavigationBarItem(
                label: '',
                icon: Icon(LineIcons.home),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(LineIcons.search),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(LineIcons.plus_circle),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(LineIcons.bell),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(LineIcons.user),
              ),
            ],
          );
        },
      ),
    );
  }
}
