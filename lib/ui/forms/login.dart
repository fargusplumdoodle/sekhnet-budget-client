import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../globals.dart';

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
          APISwitchDropdown(),
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

class APISwitchDropdown extends StatefulWidget {
  APISwitchDropdown();
  @override
  _APISwitchDropdownState createState() => _APISwitchDropdownState();
}

class _APISwitchDropdownState extends State<APISwitchDropdown> {
  final storage = new FlutterSecureStorage();
  String dropDownValue = API_HOSTS[0];

  _APISwitchDropdownState();

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: dropDownValue,
        hint: Text("API Host"),
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.tealAccent),
        underline: Container(
          height: 4,
          color: Colors.tealAccent,
        ),
        isExpanded: true,
        onChanged: onChanged,
        items: API_HOSTS.map<DropdownMenuItem<String>>((String host) {
          return DropdownMenuItem(
              value: host,
              child: Center(
                child: Text(
                  host,
                  style: TextStyle(fontSize: 20),
                ),
              ));
        }).toList());
  }

  void onChanged(String newValue) async {
    setState(() {
      dropDownValue = newValue;
    });
    await this.storage.write(key: Constants.API_HOST, value: newValue);
  }
}
