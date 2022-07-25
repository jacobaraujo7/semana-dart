import 'dart:async';

import 'package:app_client/src/auth/states/auth_state.dart';
import 'package:app_client/src/auth/stores/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:uno/uno.dart';

FutureOr<Request> addToken(Request request) {
  final authStore = Modular.get<AuthStore>();
  final state = authStore.state;

  if (state is Logged && !request.headers.containsKey('authorization')) {
    request.headers['authorization'] = 'bearer ${state.tokenization.accessToken}';
  }

  return request;
}

FutureOr tryRefreshToken(UnoError error) async {
  if (error.response?.status == 403) {
    final authStore = Modular.get<AuthStore>();
    final uno = Modular.get<Uno>();
    final state = authStore.state;
    if (state is Logged && error.request?.headers.containsKey('authorization') != true) {
      try {
        await authStore.refreshToken();
        final response = await uno.request(error.request!);
        return response;
      } on UnoError catch (e) {
        if (e.response?.status == 403) {
          authStore.logout();
        }
        return error;
      }
    }
  }

  return error;
}
