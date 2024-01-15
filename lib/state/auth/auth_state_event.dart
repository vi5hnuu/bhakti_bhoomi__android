part of 'auth_state_bloc.dart';

@immutable
abstract class AuthStateEvent {}

class LoginEvent extends AuthStateEvent {
  final String usernameEmail;
  final String password;
  LoginEvent({required this.usernameEmail, required this.password});
}
