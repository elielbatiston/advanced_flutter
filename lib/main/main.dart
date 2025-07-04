import 'package:advanced_flutter/main/factories/infra/cache/adapters/cache_manager_adapter_factory.dart';
import 'package:advanced_flutter/main/factories/ui/pages/next_evet_page_factory.dart';

import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await makeCacheManagerAdapter().save(key: 'current_user', value: { 'accessToken': 'valid_token' });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.teal, brightness: Brightness.dark);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        dividerTheme: const DividerThemeData(space: 0),
        appBarTheme: AppBarTheme(color: colorScheme.primaryContainer),
        brightness: Brightness.dark,
        colorScheme: colorScheme,
      ),
      themeMode: ThemeMode.dark,
      home: makeNextEventPage(),
    );
  }
}
