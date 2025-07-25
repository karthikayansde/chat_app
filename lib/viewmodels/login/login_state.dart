import 'package:equatable/equatable.dart';
import '../../models/user_model.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;
  final UserModel user;

  LoginSuccess({required this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
