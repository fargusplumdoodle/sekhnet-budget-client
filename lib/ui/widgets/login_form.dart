import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LoginFormData {
  String username;
  String password;
}

typedef void LoginFormCallBack(BuildContext context, LoginFormData data);

class LoginForm extends StatefulWidget {
  final LoginFormCallBack callBack;

  @override
  _LoginFormState createState() => _LoginFormState(callBack: callBack);

  LoginForm({@required LoginFormCallBack this.callBack})
      : assert(callBack != null);
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  LoginFormData _data = LoginFormData();
  final LoginFormCallBack callBack;

  _LoginFormState({@required this.callBack});

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: "Username"),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your username';
              } else {
                return null;
              }
            },
            onSaved: (String value) {
              this._data.username = value;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
            onSaved: (String value) {
              this._data.password = value;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    this.callBack(context, _data);
                  }
                },
                child: Text("Login")),
          )
        ]));
  }
}
