import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../../repositories/auth_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        final (token, user) = await repository.login(
          email: event.email,
          password: event.password,
          role: event.role,
        );
        emit(LoginSuccess(token: token, user: user));
      } catch (e) {
        emit(LoginFailure(message: e.toString()));
      }
    });
  }
}
