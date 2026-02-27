import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecases.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class SignInWithGoogleEvent extends AuthEvent {}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignUpWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  const SignUpWithEmailEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignOutEvent extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class ResetAuthEvent extends AuthEvent {}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignOut signOut;
  final CheckAuthStatus checkAuthStatus;

  AuthBloc({
    required this.signInWithGoogle,
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signOut,
    required this.checkAuthStatus,
  }) : super(AuthInitial()) {
    on<ResetAuthEvent>((event, emit) => emit(AuthInitial()));
    on<CheckAuthStatusEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await checkAuthStatus();
      result.fold(
        (failure) => emit(Unauthenticated()),
        (user) => emit(Authenticated(user)),
      );
    });

    on<SignInWithGoogleEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signInWithGoogle();
      result.fold(
        (failure) => emit(AuthError(failure)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<SignInWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signInWithEmail(event.email, event.password);
      result.fold(
        (failure) => emit(AuthError(failure)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<SignUpWithEmailEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await signUpWithEmail(event.email, event.password);
      result.fold(
        (failure) => emit(AuthError(failure)),
        (user) => emit(Authenticated(user)),
      );
    });

    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());
      await signOut();
      emit(Unauthenticated());
    });
  }
}
