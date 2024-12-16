import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geminiai/screens/SplashScreen.dart';
import 'package:geminiai/theam/theamState.dart';
import 'package:geminiai/theam/theams.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Flutter Gemini AI',
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeMode,
      home: Splashscreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
