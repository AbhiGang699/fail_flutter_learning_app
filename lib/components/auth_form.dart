import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/home_screen.dart';
import './image_input.dart';
import 'package:image_picker/image_picker.dart';
import '../models/authentication.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final Authentication obj=new Authentication();
  FirebaseUser user;
  bool isloading=false;

  var temp= TextEditingController();
  String _userName , _email ,_fullName , _password ;
  File _storedImage;
  bool _isLogin;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLogin = true;
  }

    Future<bool> check(String name) async {
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('username', isEqualTo: name)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      return documents.length ==0;
    }

    void register(BuildContext context) async{
        if(await check(_userName)==false){
          print("Username Already Exists");
          return ;
        }
        user=await obj.registerUser(_email, _password);
        print(user.uid);
        final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(user.uid + '.jpg');
        await ref.putFile(_storedImage).onComplete;

        final url = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users')
            .document(user.uid)
            .setData({
          'username': _userName,
          'email': _email,
          'image_url': url,
          'fullname':_fullName,
        });

        setState(() {
          isloading=false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(user)));

    }
  void login() async{
    user=await obj.signIn(_email, _password);
    // set route to HomeScreen( user )
    setState(() {
      isloading=false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(user)));

  }
  void _trySave(BuildContext context){
    final isValid = _formKey.currentState.validate();

    if(isValid){
      setState(() {
        isloading=true;
      });
      _formKey.currentState.save();
      if(!_isLogin){
        register(context);
      }
      else{
        login();
      }
    }
  }
  void _selectImage() async {
    showModalBottomSheet(
        // shape: ShapeBorderClipper(),
        context: context,
        builder: (_) {
          return Container(
            height: 100,
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
                      icon: Icon(
                        Icons.camera,
                        // size: 70,
                      ),
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
                      icon: Icon(
                        Icons.add_photo_alternate,
                        // size: 70,
                      ),
                      // splashColor: Colors.red,
                      label: Text('Gallery'),
                    ),
                  ],
                ),
              ),
            ),
            // behavior: HitTestBehavior.opaque,
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
                    key: _formKey,
                    child: Column(
                      children: [
                        if (!_isLogin)
                          UserImageInput(_selectImage, _storedImage),
                        if (!_isLogin)
                          TextFormField(
                            key: ValueKey('fullName'),
                            validator: (value){
                              if(value == null)return "Name can't be empty !";
                              return null;
                            },
                            onSaved: (value){
                              _fullName=value;
                            },
                            decoration: InputDecoration(labelText: 'Full Name'),
                          ),
                        TextFormField(
                          key: ValueKey('mail'),
                          validator: (mail){
                            bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(mail);
                            if(emailValid == false || mail == null)return "Enter valid e-mail !";
                            return null;
                          },
                          onSaved: (value){
                            _email=value;
                          },
                          decoration: InputDecoration(labelText: 'Email'),
                          autocorrect: false,
                        ),
                        if (!_isLogin)
                          TextFormField(
                            key: ValueKey('userName'),
                            decoration: InputDecoration(labelText: 'Username'),
                            validator: (value){
                              if(value == null)return "User Name can't be empty";
                              for(int i=0;i<value.length;++i){
                               if(value[i]==' ')return "User Name should't have spaces";
                              }
                              return null;
                            },
                            onSaved: (value){
                              _userName=value.toLowerCase();
                            },
                          ),
                        TextFormField(
                          key: ValueKey('passwrd'),
                          decoration: InputDecoration(labelText: 'Password'),
                          validator: (value){
                            if(value.length <8)return "Password is too weak !";
                            return null;
                          },
                          onSaved: (value){
                            _password=value;
                          },
                          controller: temp,
                          obscureText: true,
                        ),
                        if (!_isLogin)
                          TextFormField(
                            key: ValueKey('ConfPass'),
                            decoration:
                                InputDecoration(labelText: 'Confirm Password'),
                            validator: (value){
                              if(value !=temp.text)return "Passwords do not match !";
                              return null;
                            },
                            onSaved: (value){
                              _password=value;
                            },
                            obscureText: true,
                          ),
                        Divider(
                          height: 10,
                        ),
                        RaisedButton.icon(
                          onPressed: ()=>_trySave(context),
                          icon: Icon(Icons.exit_to_app),
                          label: isloading ? CircularProgressIndicator() : (_isLogin ? Text('Login') : Text('SignUp')),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
