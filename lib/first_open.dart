import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _tag = 'AppBlocObserver';

/// Custom [BlocObserver] that observes all bloc and cubit state changes.
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    developer.log('onCreate -- ${bloc.runtimeType}', name: _tag);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    developer.log('onEvent -- ${bloc.runtimeType}, $event', name: _tag);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    developer.log('onChange -- ${bloc.runtimeType}, $change', name: _tag);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    developer.log('onTransition -- ${bloc.runtimeType}, $transition', name: _tag);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    developer.log('onError -- ${bloc.runtimeType}, $error', name: _tag, error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    developer.log('onClose -- ${bloc.runtimeType}', name: _tag);
  }
}

final class AppLicationInitialize {
  Future<void> initialize(FutureOr<Widget> Function() builder) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      developer.log(details.exceptionAsString(), name: _tag);
    };

    await runZonedGuarded(
      () async {
        await _initialize();
        Bloc.observer = AppBlocObserver();
        runApp(await builder());
      },
      (error, stackTrace) {
        developer.log(error.toString(), name: _tag, error: error, stackTrace: stackTrace);
      },
    );
  }

  Future<void> _initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
  }
}
