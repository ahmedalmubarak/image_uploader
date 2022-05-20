part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState({
    required this.isLoading,
    this.authError,
  });
  final bool isLoading;
  final AuthError? authError;

  @override
  List<Object> get props => [isLoading];
}

@immutable
class AppInitial extends AppState {
  const AppInitial({
    required super.isLoading,
    required super.authError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;
  const AppStateLoggedIn({
    required this.user,
    required this.images,
    required super.isLoading,
    super.authError,
  });

  @override
  List<Object> get props => [isLoading, user.uid, images.length];

  @override
  bool? get stringify => true;
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required super.isLoading,
    super.authError,
  });

  @override
  bool? get stringify => true;
}

@immutable
class AppStateInRegistrationView extends AppState {
  const AppStateInRegistrationView({
    required super.isLoading,
    super.authError,
  });

  @override
  bool? get stringify => true;
}

extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}
