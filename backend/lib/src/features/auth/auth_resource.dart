import 'dart:async';
import 'dart:convert';

import 'package:backend/src/core/services/bcrypt/bcrypt_service.dart';
import 'package:backend/src/core/services/jwt/jwt_service.dart';
import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../core/services/database/remote_database.dart';
import 'guard/auth_guard.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/auth/login', _login),
        Route.get('/auth/refresh_token', _refreshToken, middlewares: [
          AuthGuard(isRefreshToken: true),
        ]),
        Route.get('/auth/check_token', _checkToken, middlewares: [AuthGuard()]),
        Route.put('/auth/update_password', _updatePassword, middlewares: [AuthGuard()]),
      ];

  FutureOr<Response> _login(Request request, Injector injector) async {
    final extractor = injector.get<RequestExtractor>();
    final bcrypt = injector.get<BCryptService>();
    final jwt = injector.get<JwtService>();
    final credential = extractor.getAuthorizationBasic(request);

    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      'SELECT id, role, password FROM "User" WHERE email = @email;',
      variables: {
        'email': credential.email,
      },
    );

    if (result.isEmpty) {
      return Response.forbidden(jsonEncode({'error': 'Email ou senha invalida'}));
    }

    final userMap = result.map((element) => element['User']).first!;

    if (!bcrypt.checkHash(credential.password, userMap['password'])) {
      return Response.forbidden(jsonEncode({'error': 'Email ou senha invalida'}));
    }

    final payload = userMap..remove('password');
    return Response.ok(jsonEncode(generateToken(payload, jwt)));
  }

  Map generateToken(Map payload, JwtService jwt) {
    payload['exp'] = _determineExpiration(Duration(minutes: 10));

    final accessToken = jwt.generateToken(payload, 'accessToken');

    payload['exp'] = _determineExpiration(Duration(days: 3));
    final refreshToken = jwt.generateToken(payload, 'refreshToken');
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  FutureOr<Response> _refreshToken(Injector injector, Request request) async {
    final extractor = injector.get<RequestExtractor>();
    final jwt = injector.get<JwtService>();

    final token = extractor.getAuthorizationBearer(request);
    var payload = jwt.getPayload(token);

    final database = injector.get<RemoteDatabase>();
    final result = await database.query(
      'SELECT id, role FROM "User" WHERE id = @id;',
      variables: {
        'id': payload['id'],
      },
    );
    payload = result.map((element) => element['User']).first!;

    return Response.ok(jsonEncode(generateToken(payload, jwt)));
  }

  FutureOr<Response> _checkToken() {
    return Response.ok(jsonEncode({'message': 'ok'}));
  }

  FutureOr<Response> _updatePassword(
    Injector injector,
    Request request,
    ModularArguments arguments,
  ) async {
    final extractor = injector.get<RequestExtractor>();
    final jwt = injector.get<JwtService>();
    final database = injector.get<RemoteDatabase>();
    final bcrypt = injector.get<BCryptService>();

    final data = arguments.data as Map;

    final token = extractor.getAuthorizationBearer(request);
    var payload = jwt.getPayload(token);

    final result = await database.query(
      'SELECT password FROM "User" WHERE id = @id;',
      variables: {
        'id': payload['id'],
      },
    );
    final password = result.map((element) => element['User']).first!['password'];

    if (!bcrypt.checkHash(data['password'], password)) {
      return Response.forbidden(jsonEncode({'error': 'senha invalida'}));
    }

    final queryUpdate = 'UPDATE "User" SET password=@password WHERE id=@id;';
    await database.query(queryUpdate, variables: {
      'id': payload['id'],
      'password': bcrypt.generateHash(data['newPassword']),
    });

    return Response.ok(jsonEncode({'message': 'ok'}));
  }

  int _determineExpiration(Duration duration) {
    final expiresDate = DateTime.now().add(duration);
    final expiresIn = Duration(milliseconds: expiresDate.millisecondsSinceEpoch);
    return expiresIn.inSeconds;
  }
}
