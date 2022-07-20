import 'package:backend/src/core/services/dot_env/dot_env_service.dart';
import 'package:backend/src/core/services/jwt/dart_jsonwebtoken/jwt_service_impl.dart';
import 'package:test/test.dart';

void main() {
  test('jwt create', () async {
    final dotEnvService = DotEnvService(mocks: {
      'JWT_KEY': 'fhsiguhoiaughr4eoiugehggoiusehgo',
    });
    final jwt = JwtServiceImpl(dotEnvService);

    final expiresDate = DateTime.now().add(Duration(seconds: 30));
    final expiresIn = Duration(milliseconds: expiresDate.millisecondsSinceEpoch).inSeconds;

    final token = jwt.generateToken({
      'id': 1,
      'role': 'user',
      'exp': expiresIn,
    }, 'accessToken');

    print(token);
  });

  test('jwt verify', () async {
    final dotEnvService = DotEnvService(mocks: {
      'JWT_KEY': 'fhsiguhoiaughr4eoiugehggoiusehgo',
    });
    final jwt = JwtServiceImpl(dotEnvService);

    jwt.verifyToken(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6InVzZXIiLCJleHAiOjE2NTgzMzI4OTQsImlhdCI6MTY1ODMzMjg2NCwiYXVkIjoiYWNjZXNzVG9rZW4ifQ.31oGSj4Wu5HwooeU16E9yclLDRZWOH96az-xmPbTjLU',
      'accessToken',
    );
  });

  test('jwt payload', () async {
    final dotEnvService = DotEnvService(mocks: {
      'JWT_KEY': 'fhsiguhoiaughr4eoiugehggoiusehgo',
    });
    final jwt = JwtServiceImpl(dotEnvService);

    final payload = jwt.getPayload(
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwicm9sZSI6InVzZXIiLCJleHAiOjE2NTgzMzI4OTQsImlhdCI6MTY1ODMzMjg2NCwiYXVkIjoiYWNjZXNzVG9rZW4ifQ.31oGSj4Wu5HwooeU16E9yclLDRZWOH96az-xmPbTjLU',
    );
    print(payload);
  });
}
