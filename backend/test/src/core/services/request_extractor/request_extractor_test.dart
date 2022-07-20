import 'dart:convert';

import 'package:backend/src/core/services/request_extractor/request_extractor.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  final extrator = RequestExtractor();

  test('getAuthorizationBearer', () async {
    final request = Request('GET', Uri.parse('http://localhost/'), headers: {
      'authorization': 'bearer flfsdhfopwsuhgoiduhgfosiduhgoiugho',
    });

    final token = extrator.getAuthorizationBearer(request);
    expect(token, 'flfsdhfopwsuhgoiduhgfosiduhgoiugho');
  });

  test('getAuthorizationBasic', () async {
    var credentialAuth = 'jacob@fteam.dev:123';
    credentialAuth = base64Encode(credentialAuth.codeUnits);

    final request = Request('GET', Uri.parse('http://localhost/'), headers: {
      'authorization': 'basic $credentialAuth',
    });

    final credential = extrator.getAuthorizationBasic(request);
    expect(credential.email, 'jacob@fteam.dev');
    expect(credential.password, '123');
  });
}
