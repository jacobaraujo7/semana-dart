import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        // login
        Route.get('/auth/login', _login),
        // refresh_token
        Route.get('/auth/refresh_token', _refreshToken),
        // check_token
        Route.get('/auth/check_token', _checkToken),
        // update_password
        Route.post('/auth/update_password', _updatePassword),
      ];

  FutureOr<Response> _login() {
    return Response.ok('');
  }

  FutureOr<Response> _refreshToken() {
    return Response.ok('');
  }

  FutureOr<Response> _checkToken() {
    return Response.ok('');
  }

  FutureOr<Response> _updatePassword() {
    return Response.ok('');
  }
}
