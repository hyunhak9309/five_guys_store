import 'package:fiveguysstore/application/config/router.dart';
import 'package:fiveguysstore/application/utils/set_initial_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setInitialData();
  //수직 모드 강제
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final router = CustomRouter().createRouter();
  runApp(ProviderScope(child: StoreApp(router: router)));
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key, required this.router});
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      builder:
          //기기 별, 텍스트 사이즈 조절 불가 강제
          (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          ),
    );
  }
}
