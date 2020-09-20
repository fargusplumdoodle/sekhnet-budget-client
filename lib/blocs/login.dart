import 'package:bloc/bloc.dart';
import 'package:budget/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoadInProgress extends LoginState {}

class LoginLoadSuccess extends LoginState {
  final LoginResponse response;

  const LoginLoadSuccess({@required this.response}) : assert(response != null);

  @override
  List<LoginResponse> get props => [response];
}

class LoginLoadFailure extends LoginState {
  final LoginResponse response;

  LoginLoadFailure({@required this.response});
}

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginRequested extends LoginEvent {
  final String username;
  final String password;

  LoginRequested(this.username, this.password)
      : assert(username != null && password != null);

  @override
  List<Object> get props => [username, password];
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({@required this.loginRepository})
      : assert(loginRepository != null),
        super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginRequested) {
      yield LoginLoadInProgress();

      final LoginResponse response =
          await loginRepository.login(event.username, event.password);

      if (response.success) {
        yield LoginLoadSuccess(response: response);
      } else {
        yield LoginLoadFailure(response: response);
      }
    }
  }
}
