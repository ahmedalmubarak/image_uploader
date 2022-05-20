part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}

@immutable
class AppEventInitialize extends AppEvent {
  const AppEventInitialize();
}

@immutable
class AppEventUploadImage extends AppEvent {
  final String filePathToUpload;

  const AppEventUploadImage({
    required this.filePathToUpload,
  });
}

@immutable
class AppEventDeleteAccount extends AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogOut extends AppEvent {
  const AppEventLogOut();
}

@immutable
class AppEventLogIn extends AppEvent {
  final String email;
  final String password;
  const AppEventLogIn({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventGoToRegistration extends AppEvent {
  const AppEventGoToRegistration();
}

@immutable
class AppEventGoToLogIn extends AppEvent {
  const AppEventGoToLogIn();
}

@immutable
class AppEventRegister extends AppEvent {
  final String email;
  final String password;
  const AppEventRegister({
    required this.email,
    required this.password,
  });
}
