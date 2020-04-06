import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet/bloc/login_bloc.dart';
import 'package:pet/screens/register.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  LoginBloc bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            emailField(bloc),
            passwordField(bloc),
            Container(margin: EdgeInsets.only(top: 25.0)),
            submitButton(bloc),
            InkResponse(
              child: Text("Don't have account?"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
            ),
            loadingIndicator(bloc)
          ],
        ),
      ),
    );
  }
}

Widget loadingIndicator(LoginBloc bloc) => StreamBuilder<bool>(
      stream: bloc.loading,
      builder: (context, snap) {
        return Container(
          child:
              (snap.hasData && snap.data) ? CircularProgressIndicator() : null,
        );
      },
    );

Widget emailField(LoginBloc bloc) => StreamBuilder<String>(
      stream: bloc.email,
      builder: (context, snap) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: bloc.changeEmail,
          decoration: InputDecoration(
              labelText: "Username", hintText: "abc123", errorText: snap.error),
        );
      },
    );

Widget passwordField(LoginBloc bloc) => StreamBuilder<String>(
    stream: bloc.password,
    builder: (context, snap) {
      return TextField(
        obscureText: true,
        onChanged: bloc.changePassword,
        decoration: InputDecoration(
            labelText: "Password", hintText: "Password", errorText: snap.error),
      );
    });

Widget submitButton(LoginBloc bloc) => StreamBuilder<bool>(
      stream: bloc.submitValid,
      builder: (context, snap) {
        return RaisedButton(
          onPressed: (!snap.hasData) ? null : bloc.submit,
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
        );
      },
    );
