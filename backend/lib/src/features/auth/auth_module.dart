import 'package:backend/src/features/auth/datasources/auth_datasource_impl.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'repositories/auth_repository.dart';
import 'resources/auth_resource.dart';

class AuthModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<AuthDatasource>((i) => AuthDatasourceImpl(i())),
        Bind.singleton((i) => AuthRepository(i(), i(), i())),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(AuthResource()),
      ];
}
