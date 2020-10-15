import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  var email =  TextEditingController();
  var pass = TextEditingController();
  var userName = TextEditingController();
  var fullName = TextEditingController();

  Function registerFunc;
  RegisterScreen(this.registerFunc);

  Widget build (BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Full Name ',
              labelStyle: TextStyle(
                fontSize: 12,
              ),
            ),
            controller: fullName,
            keyboardType: TextInputType.name,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email-Id',
              labelStyle: TextStyle(
                fontSize: 12,
              ),
            ),
            controller: email,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(
                fontSize: 12,
              ),
            ),
            controller: userName,
            keyboardType: TextInputType.name,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(
                fontSize: 12,
              ),
            ),
            controller: pass,
            keyboardType: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }
}