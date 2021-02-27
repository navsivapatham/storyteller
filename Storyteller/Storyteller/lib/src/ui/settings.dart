import 'package:flutter/material.dart';
import 'package:Storyteller/src/constant/httpService.dart';
import 'package:connectivity/connectivity.dart';
import 'login.dart';
import 'edit_profile.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:line_icons/line_icons.dart';

class SettingsForm extends StatefulWidget {
  @override
  StoryTellerSettings createState() => new StoryTellerSettings();
}

class StoryTellerSettings extends State<SettingsForm> {
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
  }

  @override
  Widget build(BuildContext context) {
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
                floating: true,
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'SFProDisplayRegular',
                    fontSize: 20.0,
                  ),
                ),
                centerTitle: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserForm(),
                          ),
                        );
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.10,
                            width: kToolbarHeight / 1.10,
                            child: Icon(LineIcons.edit),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text('Edit Profile'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          await launch('link');
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.10,
                            width: kToolbarHeight / 1.10,
                            child: Icon(LineIcons.book),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text('Terms & Conditions'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text('Do you want to Log Out?'),
                              content:
                                  new Text("You'll have to Log In once more!"),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
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
                                  onPressed: () {
                                    check().then(
                                      (internet) async {
                                        if (internet == false) {
                                        } else {
                                          await HttpService().logout();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginForm(),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: new Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          leading: Container(
                            height: kToolbarHeight / 1.10,
                            width: kToolbarHeight / 1.10,
                            child: Icon(LineIcons.sign_out),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text('Log Out'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
}
