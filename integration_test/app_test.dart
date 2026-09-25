import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:emprendeplus_app/models/usuario.dart';
import 'package:emprendeplus_app/repositories/auth_repository.dart';
import 'package:emprendeplus_app/screens/login_screen.dart';

class FakeAuthRepository extends AuthRepository {
  bool sesionIniciada = false;

  @override
  Future<Usuario> iniciarSesion(
    String correo,
    String contrasena,
  ) async {
    sesionIniciada = true;

    return Usuario(
      id: 2,
      nombre: 'Alberto Muñoz',
      correo: correo,
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Flujo crítico: iniciar sesión y cerrar sesión',
    (tester) async {
      final authRepository = FakeAuthRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(
            authRepository: authRepository,
          ),
          routes: {
            '/inicio': (context) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Inicio'),
                ),
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Cerrar sesión'),
                  ),
                ),
              );
            },
          },
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Iniciar sesión'), findsOneWidget);

      final campos = find.byType(TextField);

      expect(campos, findsNWidgets(2));

      await tester.enterText(
        campos.at(0),
        'alberto@prueba.com',
      );

      await tester.enterText(
        campos.at(1),
        '123456',
      );

      await tester.tap(
        find.text('Iniciar sesión'),
      );

      await tester.pumpAndSettle();

      expect(authRepository.sesionIniciada, isTrue);

      expect(find.text('Inicio'), findsOneWidget);

      await tester.tap(
        find.text('Cerrar sesión'),
      );

      await tester.pumpAndSettle();

      expect(find.text('Iniciar sesión'), findsOneWidget);
    },
  );
}
