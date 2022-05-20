import 'dart:io';
import 'package:bloc_fairebase_auth/utils/upload_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_fairebase_auth/auth/auth_error.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateLoggedOut(isLoading: false)) {
    on<AppEventGoToRegistration>((event, emit) {
      emit(
        const AppStateInRegistrationView(isLoading: false),
      );
    });
    // handel user log in
    on<AppEventLogIn>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));

      // log user in
      try {
        final email = event.email;
        final password = event.password;
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user;
        final images = await _getImages(user!.uid);
        emit(AppStateLoggedIn(
          user: user,
          images: images,
          isLoading: false,
        ));
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(isLoading: false, authError: AuthError.from(e)),
        );
      }
    });

    on<AppEventGoToLogIn>((event, emit) {
      emit(const AppStateLoggedOut(isLoading: false));
    });

    // handel register new account
    on<AppEventRegister>((event, emit) async {
      // start loading
      emit(
        const AppStateInRegistrationView(isLoading: true),
      );
      final email = event.email;
      final password = event.password;
      try {
        // create new user
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final userId = credential.user!.uid;
        emit(
          AppStateLoggedIn(
            user: credential.user!,
            images: const [],
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    on<AppEventInitialize>((event, emit) async {
      // get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
      } else {
        // go grab the user's uploaded images
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      }
    });

    // handel log out event
    on<AppEventLogOut>((event, emit) async {
      // start loading
      emit(const AppStateLoggedOut(isLoading: true));
      // log user out
      await FirebaseAuth.instance.signOut();
      // log the user out in the UI as well.
      emit(const AppStateLoggedOut(isLoading: false));
    });

    // handel account deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      // log user out if we don't have current user
      if (user == null) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
        return;
      }
      // start loading
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );

      // delete user
      try {
        final folderItems =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (var item in folderItems.items) {
          await item.delete().catchError((_) {});
        }

        // delete folder it self
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});

        // delete a user.
        await user.delete();

        // log the user out
        await FirebaseAuth.instance.signOut();

        //log the user out in the ui as well.
        emit(const AppStateLoggedOut(isLoading: false));
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
              isLoading: true,
              user: user,
              images: state.images ?? [],
              authError: AuthError.from(e)),
        );
      } on FirebaseException catch (e) {
        // we might be able to delete the folder.
        // log the user out
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
      }
    });

    // handel uploading images
    on<AppEventUploadImage>(
      (event, emit) async {
        final user = state.user;
        // logged user out if we don't have an actual user in app
        if (user == null) {
          emit(const AppStateLoggedOut(isLoading: false));
          return;
        }
        // start the loading process.
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );
        // upload the file
        final file = File(event.filePathToUpload);
        await uploadImage(
          file: file,
          userId: user.uid,
        );

        // after upload is complete, grab the latest file reference
        final images = await _getImages(user.uid);
        // emit the new images  and turn off loading
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      },
    );
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
