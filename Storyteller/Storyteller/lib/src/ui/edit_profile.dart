import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import 'package:Storyteller/src/models/user_model.dart';
import 'package:line_icons/line_icons.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../blocs/profile_bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';

class EditUserForm extends StatefulWidget {
  @override
  StoryTellerEditProfile createState() => new StoryTellerEditProfile();
}

class StoryTellerEditProfile extends State<EditUserForm> {
  File _image;
  String name;
  String email;
  String bio;
  final GlobalKey<FormState> _formKey4 = GlobalKey<FormState>();

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
          bloc.fetchUser(0);
          bloc.userFetcherStatus.listen((onData) {}, onError: (_) {});
        }
      },
    );
  }

  @override
  void dispose() {
    bloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey4,
      child: Scaffold(
        body: StreamBuilder(
          stream: bloc.userDetail,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {}
            if (snapshot.hasData) {
              return new Stack(
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
                        centerTitle: true,
                        title: Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontFamily: 'SFProDisplayRegular',
                            fontSize: 20.0,
                          ),
                        ),
                        actions: [
                          IconButton(
                            icon: Icon(LineIcons.check),
                            onPressed: () async {
                              try {
                                if (_formKey4.currentState.validate() == true) {
                                  if (_image == null) {
                                    var userModel = User.editNoPhoto(
                                      (name != null)
                                          ? name
                                          : snapshot.data.user.name,
                                      (email != null)
                                          ? email
                                          : snapshot.data.user.email,
                                      (bio != null)
                                          ? bio
                                          : snapshot.data.user.bio,
                                    );

                                    await bloc.editUser(userModel);
                                    savedShow();
                                  } else {
                                    String base64Image =
                                        base64Encode(_image.readAsBytesSync());
                                    var userModel = User.edit(
                                      (name != null)
                                          ? name
                                          : snapshot.data.user.name,
                                      (email != null)
                                          ? email
                                          : snapshot.data.user.email,
                                      (bio != null)
                                          ? bio
                                          : snapshot.data.user.bio,
                                      base64Image,
                                    );

                                    await bloc.editUser(userModel);
                                    savedShow();
                                  }
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                          )
                        ],
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SizedBox(
                              height: 20.0,
                            ),
                            new Container(
                              width: screenSize.width,
                              child: new Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: _getImage,
                                      child: (_image != null)
                                          ? new Container(
                                              height: kToolbarHeight * 1.80,
                                              width: kToolbarHeight * 1.80,
                                              decoration: new BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                image: DecorationImage(
                                                  image: FileImage(_image),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : Stack(
                                              alignment: AlignmentDirectional
                                                  .topCenter,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0),
                                                  child: Container(
                                                    height:
                                                        kToolbarHeight * 1.80,
                                                    width:
                                                        kToolbarHeight * 1.80,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl: snapshot
                                                          .data.user.avatar,
                                                    ),
                                                  ),
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          20.0),
                                                  child: Container(
                                                    height:
                                                        kToolbarHeight * 1.80,
                                                    width:
                                                        kToolbarHeight * 1.80,
                                                    color: Color.fromRGBO(
                                                            61, 131, 255, 1)
                                                        .withOpacity(0.3),
                                                  ),
                                                ),
                                                Container(
                                                  height: kToolbarHeight * 1.80,
                                                  width: kToolbarHeight * 1.80,
                                                  child: Center(
                                                    child: Icon(
                                                      LineIcons.edit,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            new Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new TextFormField(
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                initialValue: snapshot.data.user.name,
                                autofocus: false,
                                onChanged: (text) {
                                  print("First text field: $text");
                                  setState(() {
                                    name = text;
                                  });
                                },
                                validator: Validators.compose([
                                  Validators.required('Username is required'),
                                  Validators.minLength(5,
                                      'Username cannot be less than 5 characters'),
                                  Validators.maxLength(120,
                                      'Username cannot be greater than 120 characters'),
                                ]),
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      15.0, 15.0, 15.0, 15.0),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            new Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new TextFormField(
                                initialValue: snapshot.data.user.email,
                                keyboardType: TextInputType.emailAddress,
                                maxLines: 1,
                                autofocus: false,
                                onChanged: (text) {
                                  print("First text field: $text");
                                  setState(() {
                                    email = text;
                                  });
                                },
                                validator: Validators.compose([
                                  Validators.required('Email is required'),
                                  Validators.email('Invalid email address'),
                                  Validators.minLength(5,
                                      'Email cannot be less than 5 characters'),
                                  Validators.maxLength(120,
                                      'Email cannot be greater than 120 characters'),
                                ]),
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  contentPadding: EdgeInsets.fromLTRB(
                                      15.0, 15.0, 15.0, 15.0),
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            new Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: new TextFormField(
                                initialValue: snapshot.data.user.bio,
                                keyboardType: TextInputType.text,
                                autofocus: false,
                                maxLines: null,
                                onChanged: (text) {
                                  print("First text field: $text");
                                  setState(() {
                                    bio = text;
                                  });
                                },
                                validator: Validators.compose([
                                  Validators.required('Bio is required'),
                                  Validators.minLength(5,
                                      'Bio cannot be less than 5 characters'),
                                  Validators.maxLength(512,
                                      'Bio cannot be greater than 512 characters'),
                                ]),
                                decoration: InputDecoration(
                                  hintText: 'Bio',
                                  filled: true,
                                  fillColor: Theme.of(context).cardColor,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      15.0, 15.0, 15.0, 15.0),
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
              );
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

  void savedShow() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Good job!'),
          content: new Text("Everything is saved!"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future _getImage() async {
    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('How do you want to grab it?'),
            content: new Text("Choose your favorite way!"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Gallery"),
                onPressed: () async {
                  var image1 = await ImagePicker.pickImage(
                      source: ImageSource.gallery, imageQuality: 50);
                  Navigator.pop(context);
                  setState(() {
                    _image = image1;
                  });
                },
              ),
              new FlatButton(
                child: new Text("Camera"),
                onPressed: () async {
                  var image2 = await ImagePicker.pickImage(
                      source: ImageSource.camera, imageQuality: 50);
                  Navigator.pop(context);
                  setState(() {
                    _image = image2;
                  });
                },
              ),
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } catch (error) {}
  }
}
