import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/authentication.dart';
import '../components/registerScreen.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final email= TextEditingController();
  final pass=TextEditingController();
  final Authentication obj=new Authentication();
  FirebaseUser user;
  bool isSucces;

  bool isValid(String mail,String pass){
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(mail);
    if(emailValid== false || pass==null )return false;
    return true;
  }


  void _register(String mail,String passwd) async{
    if(isValid(email.text,pass.text)==false ){
      print("Details Invalid !!");
      return;
    }
    try{
      user= await obj.registerUser(mail, passwd);
      print("Registration Successful !!");
      print(user.uid);
      setState(() {
        isSucces=true;
        email.clear();
        pass.clear();
      });
    }
    catch(e){
      print(e.toString());
      print("Unsuccessful Registration ");
    }
  }

  void _openRegister(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (_){
          return RegisterScreen(_register);
        });
  }
  void _login() async {
    if(isValid(email.text,pass.text)==false) {
      print("Details invalid");
      return;
      }
      try{
        user = await obj.signIn(email.text, pass.text);
        print("Successful Login !!");
        print(user.uid);
        setState(() {
          isSucces=true;
          email.clear();
          pass.clear();
        });
      }
      catch(e){
        print("Login Failed !!");
      }
  }

  Widget build( BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body:LayoutBuilder(
          builder:(cxt,constraints){
            var _bodyHeight=constraints.maxHeight;
            var _bodyWidth=constraints.maxWidth;
          return  Container(
            height: _bodyHeight,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: _bodyHeight * 0.2,
                  width: _bodyWidth * 0.5,

                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Container(
                  height: _bodyHeight * 0.2,
                  width: _bodyWidth * 0.5,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    controller: pass,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ),
                RaisedButton(
                  child: Text("Login"),
                  onPressed: _login,
                ),
                RaisedButton(
                  child: Text("Create Account"),
                  onPressed: ()=> _openRegister(context),
                ),
              ],
            ),
          ),
        );}),

    );
  }
}