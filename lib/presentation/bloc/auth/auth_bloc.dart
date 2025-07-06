import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  
  const AuthSignUpRequested({required this.email, required this.password});
  
  @override
  List<Object?> get props => [email, password];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  
  const AuthSignInRequested({required this.email, required this.password});
  
  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  
  const AuthAuthenticated({required this.user});
  
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
  }
  
  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    final user = _authRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user: user));
    } else {
      emit(AuthUnauthenticated());
    }
  }
  
  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: userCredential.user!));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
  
  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authRepository.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user: userCredential.user!));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
  
  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}