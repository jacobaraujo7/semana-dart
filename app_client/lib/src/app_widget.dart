import 'package:app_client/src/auth/states/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'auth/stores/auth_store.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();

    final store = context.read<AuthStore>();

    store.observer(onState: (state) {
      if (state is Logged) {
        // home
        Modular.to.navigate('/home');
      } else if (state is Unlogged) {
        // auth
        Modular.to.navigate('/auth/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/auth/login');

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
    );
  }
}
