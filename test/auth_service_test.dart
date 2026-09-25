import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:emprendeplus_app/services/auth_service.dart';

class FakeSecureStorage implements SecureStorageAdapter {
  final Map<String, String> _data = {};

  @override
  Future<void> write({
    required String key,
    required String value,
  }) async {
    _data[key] = value;
  }

  @override
  Future<String?> read({
    required String key,
  }) async {
    return _data[key];
  }

  @override
  Future<void> delete({
    required String key,
  }) async {
    _data.remove(key);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    AuthService.configurarAlmacenamientoParaPruebas(
      FakeSecureStorage(),
    );
  });

  tearDown(() {
    AuthService.restaurarAlmacenamientoReal();
  });

  test(
    'Una sesión sin token no debe considerarse autenticada',
    () async {
      final autenticado = await AuthService.estaAutenticado();

      expect(autenticado, isFalse);
    },
  );

  test(
    'Una sesión con token debe considerarse autenticada',
    () async {
      await AuthService.guardarSesion(
        token: 'token-prueba',
        nombre: 'Usuario Prueba',
        correo: 'usuario@prueba.com',
      );

      final autenticado = await AuthService.estaAutenticado();

      expect(autenticado, isTrue);

      expect(
        await AuthService.obtenerToken(),
        'token-prueba',
      );
    },
  );

  test(
    'Cerrar sesión debe eliminar los datos de la sesión',
    () async {
      await AuthService.guardarSesion(
        token: 'token-prueba',
        nombre: 'Usuario Prueba',
        correo: 'usuario@prueba.com',
      );

      await AuthService.cerrarSesion();

      final autenticado = await AuthService.estaAutenticado();
      final token = await AuthService.obtenerToken();
      final nombre = await AuthService.obtenerNombre();
      final correo = await AuthService.obtenerCorreo();

      expect(autenticado, isFalse);
      expect(token, isNull);
      expect(nombre, isNull);
      expect(correo, isNull);
    },
  );
}

