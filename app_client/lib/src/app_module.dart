import 'package:app_client/src/auth/login_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:modular_triple_bind/modular_triple_bind.dart';
import 'package:uno/uno.dart';

import 'auth/interceptors/interceptors.dart';
import 'auth/stores/auth_store.dart';
import 'home/home_page.dart';

class AppModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton((i) {
          final uno = Uno(baseURL: 'http://146.190.226.218:4466');
          uno.interceptors.request.use(addToken);
          uno.interceptors.response.use(
            (response) => response,
            onError: tryRefreshToken,
          );
          return uno;
        }),
        TripleBind.singleton((i) => AuthStore(i())),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/auth/login', child: (_, __) => const LoginPage()),
        ChildRoute('/home', child: (_, __) => const HomePage()),
      ];
}
