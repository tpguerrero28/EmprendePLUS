import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:emprendeplus_app/models/usuario.dart';
import 'package:emprendeplus_app/repositories/auth_repository.dart';
import 'package:emprendeplus_app/screens/login_screen.dart';
import 'package:emprendeplus_app/theme/app_theme.dart';

class FakeAuthRepository extends AuthRepository {
  @override
  Future<Usuario> iniciarSesion(
    String correo,
    String contrasena,
  ) async {
    throw Exception('Credenciales incorrectas');
  }
}

Widget crearLoginParaPrueba({
  AuthRepository? authRepository,
}) {
  final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(
          authRepository: authRepository,
        ),
      ),
      GoRoute(
        path: '/inicio',
        builder: (context, state) => const Scaffold(
          body: Text('Inicio'),
        ),
      ),
    ],
  );

  return MaterialApp.router(
    theme: AppTheme.theme,
    routerConfig: router,
  );
}

void main() {
  testWidgets(
    'Login muestra los elementos principales de la interfaz',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        crearLoginParaPrueba(),
      );

      await tester.pumpAndSettle();

      expect(find.text('EmprendePLUS'), findsOneWidget);
      expect(find.text('Correo electrónico'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.text('Iniciar sesión'), findsOneWidget);
    },
  );

  testWidgets(
    'Login no permite iniciar sesión con campos vacíos',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        crearLoginParaPrueba(),
      );

      await tester.pumpAndSettle();

      final botonLogin = find.text('Iniciar sesión');

      expect(botonLogin, findsOneWidget);

      await tester.tap(botonLogin);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);

      expect(
        find.textContaining('Ingrese el correo'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'El botón de contraseña permite mostrar y ocultar la contraseña',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        crearLoginParaPrueba(),
      );

      await tester.pumpAndSettle();

      expect(
        find.byIcon(Icons.visibility),
        findsOneWidget,
      );

      await tester.tap(
        find.byIcon(Icons.visibility),
      );

      await tester.pump();

      expect(
        find.byIcon(Icons.visibility_off),
        findsOneWidget,
      );

      await tester.tap(
        find.byIcon(Icons.visibility_off),
      );

      await tester.pump();

      expect(
        find.byIcon(Icons.visibility),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Login muestra un mensaje cuando ocurre un error al iniciar sesión',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        crearLoginParaPrueba(
          authRepository: FakeAuthRepository(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'correo@prueba.com',
      );

      await tester.enterText(
        find.byType(TextField).last,
        '123456',
      );

      await tester.tap(
        find.text('Iniciar sesión'),
      );

      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);

      expect(
        find.text('Credenciales incorrectas'),
        findsOneWidget,
      );
    },
  );
}