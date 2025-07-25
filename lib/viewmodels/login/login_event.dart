import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final String role;

  LoginSubmitted({required this.email, required this.password, required this.role});

  @override
  List<Object?> get props => [email, password, role];
}
