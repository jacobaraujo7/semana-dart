import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'src/app_module.dart';

Future<Handler> startShelfModular() async {
  final handler = Modular(module: AppModule(), middlewares: [
    logRequests(),
    jsonResponse(),
  ]);
  return handler;
}

Middleware jsonResponse() {
  return (handler) {
    return (request) async {
      var response = await handler(request);

      response = response.change(headers: {
        'content-type': 'application/json',
        ...response.headers,
      });

      return response;
    };
  };
}
