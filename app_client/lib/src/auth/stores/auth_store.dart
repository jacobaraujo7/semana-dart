import 'dart:convert';

import 'package:app_client/src/auth/dto/login_credential.dart';
import 'package:app_client/src/auth/models/tokenization.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:uno/uno.dart';

import '../errors/errors.dart';
import '../states/auth_state.dart';

class AuthStore extends StreamStore<AuthException, AuthState> {
  final Uno uno;

  AuthStore(this.uno) : super(InProccess());

  Future<void> login(LoginCredential credential) async {
    setLoading(true);

    var basic = '${credential.email.value}:${credential.password.value}';

    basic = base64Encode(basic.codeUnits);

    // amFjb2JAZnRlYW0uZGV2OjEyMw==

    try {
      final response = await uno.get(
        '/auth/login',
        headers: {'authorization': 'basic $basic'},
      );

      final tokenization = Tokenization.fromMap(response.data);

      update(Logged(tokenization));
    } on UnoError catch (e, s) {
      setError(AuthException(e.message, s));
    }
  }

  Future<void> refreshToken() async {
    final state = this.state;
    if (state is Logged) {
      final refreshTokenString = state.tokenization.refreshToken;

      final response = await uno.get('auth/refresh_token', headers: {
        'refreshed_token': '',
        'authorization': 'bearer $refreshTokenString',
      });
      final tokenization = Tokenization.fromMap(response.data);
      update(Logged(tokenization));
    }
  }

  logout() {
    update(Unlogged());
  }
}
