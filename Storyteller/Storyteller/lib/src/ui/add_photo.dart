import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Storyteller/src/models/image_model.dart';
import 'package:wc_form_validators/wc_form_validators.dart';
import '../blocs/photos_bloc.dart';
import 'package:connectivity/connectivity.dart';

class PhotoForm extends StatefulWidget {
  @override
  StoryTellerAddPhoto createState() => new StoryTellerAddPhoto();
}

class StoryTellerAddPhoto extends State<PhotoForm> {
  File _image;
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  bool up = false;
  List<String> main = List();

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
          bloc.photoFetcherStatus.listen((onData) {});
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
      key: _formKey3,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                new Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  width: screenSize.width,
                  height: screenSize.width - 20.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Theme.of(context).cardColor,
                  ),
                  child: _image == null
                      ? Container(
                          child: Center(
                            child: Container(
                              height: kToolbarHeight * 1.80,
                              width: kToolbarHeight * 1.80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                color: Theme.of(context).canvasColor,
                              ),
                              child: new Material(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                  onTap: () => {
                                    _getImage(),
                                  },
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      size: kToolbarHeight * 0.65,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    minLines: 3,
                    maxLines: null,
                    autofocus: false,
                    validator: Validators.compose([
                      Validators.required('Description is required'),
                      Validators.minLength(
                          5, 'Description cannot be less than 5 characters'),
                      Validators.maxLength(2560,
                          'Description cannot be greater than 2560 characters'),
                    ]),
                    decoration: InputDecoration(
                      hintText: 'Write something about your Post...',
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                ButtonTheme(
                  height: kToolbarHeight / 1.20,
                  minWidth: MediaQuery.of(context).size.width / 1.3,
                  child: RaisedButton(
                      color: Color.fromRGBO(61, 131, 255, 1),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0)),
                      child: new Text(
                        "Publish",
                        style: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: 'SFProDisplayRegular'),
                      ),
                      onPressed: () {
                        check().then((internet) async {
                          if (internet == false) {
                          } else {
                            if (_formKey3.currentState.validate() == true) {
                              if (_image == null) return;

                              String base64Image =
                                  base64Encode(_image.readAsBytesSync());
                              var image = Data.add(
                                1,
                                base64Image,
                                1,
                                1,
                                descriptionController.text,
                              );
                              bloc.saveImage(image);
                              savedShow();
                            }
                          }
                        });
                      }),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
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
          content: new Text("Your Post is posted!"),
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
