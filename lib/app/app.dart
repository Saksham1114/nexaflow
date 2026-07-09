import 'package:flutter/material.dart';

import 'package:nexaflow/app/router.dart';
import 'package:nexaflow/app/theme/app_theme.dart';

class NexaFlowApp extends StatelessWidget {
  const NexaFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const Scaffold(body: Center(child: Text("NexaFlow"))),
    );
  }
}
