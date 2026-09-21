import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'routes/app_router.dart';
import 'services/notification_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await NotificationService.inicializar();

  runApp(const EmprendePlusApp());
}

class EmprendePlusApp extends StatelessWidget {
  const EmprendePlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'EmprendePLUS',
      theme: AppTheme.theme,
      routerConfig: appRouter,
    );
  }
}