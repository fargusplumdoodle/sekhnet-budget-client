import 'package:budget/blocs/login.dart';
import 'package:budget/repositories/login.dart';
import 'package:budget/ui/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "LoginScreen";
  final _loginRepo = LoginRepository(loginClient: LoginApiClient());

  @override
  Widget build(BuildContext context) {
    initLogin().then((loginRequired) => {
          if (!loginRequired)
            Navigator.popAndPushNamed(context, Dashboard.routeName)
        });

    return Scaffold(
      appBar: loginAppBar(),
      body: BlocProvider(
          create: (context) => LoginBloc(loginRepository: _loginRepo),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: blocBuilder,
          )),
    );
  }

  Widget blocBuilder(context, state) {
    var loginScreenWidgets = <Widget>[
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(callBack: submitCredentials),
      )
    ];

    if (state is LoginLoadFailure) {
      loginScreenWidgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Login failed: ${state.response.errorMsg}",
          style: TextStyle(color: Colors.red),
        ),
      ));
    }

    if (state is LoginLoadInProgress) {
      loginScreenWidgets.add(CircularProgressIndicator());
    }

    if (state is LoginLoadSuccess) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, Dashboard.routeName);
      });
    }

    return Column(
      children: loginScreenWidgets,
    );
  }

  void submitCredentials(BuildContext context, LoginFormData data) {
    BlocProvider.of<LoginBloc>(context)
        .add(LoginRequested(data.username, data.password));
  }

  Widget loginAppBar() {
    return AppBar(
        title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Sekhnet Budget - Login"),
      ],
    ));
  }
}
