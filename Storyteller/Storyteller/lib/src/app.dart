import 'package:flutter/material.dart';
import 'ui/bottomNavigation.dart';
import 'package:flutter/services.dart';
import 'blocs/login_bloc.dart';
import 'ui/login.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    bloc.fetchUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardColor: Colors.grey[100],
        brightness: Brightness.light,
        accentColor: Colors.blue,
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        canvasColor: Colors.white,
        primaryIconTheme: IconThemeData(
          color: Colors.black,
        ),
        primaryTextTheme: TextTheme(
          headline6:
              TextStyle(color: Colors.black, fontFamily: "SFProDisplayRegular"),
        ),
        textTheme: TextTheme(
          headline6: TextStyle(color: Colors.black),
        ),
      ),
      home: Scaffold(
        body: StreamBuilder(
          stream: bloc.getUser,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return LoginForm();
            }
            if (snapshot.hasData) {
              return StoryTellerBottom();
            }

            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
