import 'dart:io';

import 'package:flutter/material.dart';
import './image_input.dart';
import '../enums.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  File _storedImage;
  AuthMode usermode;
  bool _isLogin;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLogin = true;
  }

  void _selectImage() async {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
            child: Center(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton.icon(
                      onPressed: () async {
                        final _picker = ImagePicker();
                        final _picked = await _picker.getImage(
                            source: ImageSource.camera, imageQuality: 50);
                        if (File(_picked.path) == null) return null;

                        setState(() {
                          _storedImage = File(_picked.path);
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.camera),
                      label: Text('Camera'),
                    ),
                    FlatButton.icon(
                      onPressed: () async {
                        final _picker = ImagePicker();
                        final _picked = await _picker.getImage(
                            source: ImageSource.gallery, imageQuality: 50);
                        if (_picked == null) return null;

                        setState(() {
                          _storedImage = File(_picked.path);
                        });
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.add_photo_alternate),
                      label: Text('Gallery'),
                    ),
                  ],
                ),
              ),
            ),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Card(
          elevation: 40,
          margin: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Form(
                      child: Column(
                    children: [
                      if (!_isLogin) UserImageInput(_selectImage, _storedImage),
                      if (!_isLogin)
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Full Name'),
                        ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        autocorrect: false,
                      ),
                      if (!_isLogin)
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Username'),
                        ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      if (!_isLogin)
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          obscureText: true,
                        ),
                      Divider(
                        height: 10,
                      ),
                      RaisedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.exit_to_app),
                        label: _isLogin ? Text('Login') : Text('SignUp'),
                      ),
                      Divider(
                        height: 10,
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'I don\'t have an account'
                            : 'Already have an account'),
                      ),
                    ],
                  ))
                  // if()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
