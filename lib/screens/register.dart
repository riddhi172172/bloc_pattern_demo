import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet/bloc/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  RegisterBloc bloc = RegisterBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            usernameField(bloc),
            emailField(bloc),
            passwordField(bloc),
            password2Field(bloc),
            Container(margin: EdgeInsets.only(top: 25.0)),
            submitButton(bloc),
            loadingIndicator(bloc)
          ],
        ),
      ),
    );
  }
}

Widget loadingIndicator(RegisterBloc bloc) => StreamBuilder<bool>(
      stream: bloc.loading,
      builder: (context, snap) {
        return Container(
          child:
              (snap.hasData && snap.data) ? CircularProgressIndicator() : null,
        );
      },
    );

Widget usernameField(RegisterBloc bloc) => StreamBuilder<String>(
      stream: bloc.username,
      builder: (context, snap) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: bloc.changeUsername,
          decoration: InputDecoration(
              labelText: "Username", hintText: "abc123", errorText: snap.error),
        );
      },
    );

Widget emailField(RegisterBloc bloc) => StreamBuilder<String>(
      stream: bloc.email,
      builder: (context, snap) {
        return TextField(
          keyboardType: TextInputType.emailAddress,
          onChanged: bloc.changeEmail,
          decoration: InputDecoration(
              labelText: "Email address",
              hintText: "you@example.com",
              errorText: snap.error),
        );
      },
    );

Widget passwordField(RegisterBloc bloc) => StreamBuilder<String>(
    stream: bloc.password,
    builder: (context, snap) {
      return TextField(
        obscureText: true,
        onChanged: bloc.changePassword,
        decoration: InputDecoration(
            labelText: "Password", hintText: "Password", errorText: snap.error),
      );
    });

Widget password2Field(RegisterBloc bloc) => StreamBuilder<String>(
    stream: bloc.password2,
    builder: (context, snap) {
      return TextField(
        obscureText: true,
        onChanged: bloc.changePassword2,
        decoration: InputDecoration(
            labelText: "Confirm Password",
            hintText: "Confirm Password",
            errorText: snap.error),
      );
    });

Widget submitButton(RegisterBloc bloc) => StreamBuilder<bool>(
      stream: bloc.submitValid,
      builder: (context, snap) {
        return RaisedButton(
          onPressed: (!snap.hasData) ? null : bloc.submit,
          child: Text(
            "Register",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
        );
      },
    );
