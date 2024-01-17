part of 'auth_state_bloc.dart';

@immutable
abstract class AuthStateEvent {}

class LoginEvent extends AuthStateEvent {
  final String usernameEmail;
  final String password;
  LoginEvent({required this.usernameEmail, required this.password});
}

class RegisterEvent extends AuthStateEvent {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final XFile? profilePic;
  final XFile? posterPic;

  RegisterEvent({required this.firstName, required this.lastName, required this.username, required this.email, required this.password, this.profilePic, this.posterPic});
}
