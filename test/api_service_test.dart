import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:emprendeplus_app/models/usuario.dart';
import 'package:emprendeplus_app/services/api_service.dart';
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

class FakePreferences implements PreferencesAdapter {
  final Map<String, String> _data = {};

  @override
  Future<void> setString(String key, String value) async {
    _data[key] = value;
  }

  @override
  String? getString(String key) {
    return _data[key];
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }
}

Dio crearDioDePrueba({
  int statusCode = 200,
  dynamic data,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://servidor-prueba.local',
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (statusCode >= 400) {
          handler.reject(
            DioException(
              requestOptions: options,
              response: Response(
                requestOptions: options,
                statusCode: statusCode,
                data: data,
              ),
            ),
          );
          return;
        }

        handler.resolve(
          Response(
            requestOptions: options,
            statusCode: statusCode,
            data: data,
          ),
        );
      },
    ),
  );

  return dio;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    AuthService.configurarAlmacenamientoParaPruebas(
      FakeSecureStorage(),
    );

    AuthService.configurarPreferenciasParaPruebas(
      FakePreferences(),
    );
  });

  test(
    'Login con respuesta 200 debe devolver el usuario y guardar el token',
    () async {
      final dio = crearDioDePrueba(
        statusCode: 200,
        data: {
          'token': 'token-prueba',
          'usuario': {
            'id': 2,
            'nombre': 'Alberto Muñoz',
            'correo': 'alberto@prueba.com',
          },
        },
      );

      ApiService.configurarDioParaPruebas(dio);

      final usuario = await ApiService.iniciarSesion(
        'alberto@prueba.com',
        '123456',
      );

      expect(usuario, isA<Usuario>());
      expect(usuario.id, 2);
      expect(usuario.nombre, 'Alberto Muñoz');
      expect(usuario.correo, 'alberto@prueba.com');

      expect(
        await AuthService.obtenerToken(),
        'token-prueba',
      );
    },
  );

  test(
    'Login con respuesta 401 debe informar credenciales incorrectas',
    () async {
      final dio = crearDioDePrueba(
        statusCode: 401,
        data: {
          'mensaje': 'Credenciales incorrectas',
        },
      );

      ApiService.configurarDioParaPruebas(dio);

      expect(
        () => ApiService.iniciarSesion(
          'correo@prueba.com',
          'clave-incorrecta',
        ),
        throwsA(
          predicate(
            (error) => error.toString().contains(
                  'Correo o contrase',
                ),
          ),
        ),
      );
    },
  );

  test(
    'Login con respuesta 403 debe informar falta de permisos',
    () async {
      final dio = crearDioDePrueba(
        statusCode: 403,
        data: {
          'mensaje': 'Acceso denegado',
        },
      );

      ApiService.configurarDioParaPruebas(dio);

      expect(
        () => ApiService.iniciarSesion(
          'correo@prueba.com',
          '123456',
        ),
        throwsA(
          predicate(
            (error) => error.toString().contains(
                  'No tiene permisos',
                ),
          ),
        ),
      );
    },
  );

  test(
    'Login con respuesta 200 sin token debe informar respuesta incompleta',
    () async {
      final dio = crearDioDePrueba(
        statusCode: 200,
        data: {
          'usuario': {
            'id': 2,
            'nombre': 'Usuario de Prueba',
            'correo': 'usuario@prueba.com',
          },
        },
      );

      ApiService.configurarDioParaPruebas(dio);

      expect(
        () => ApiService.iniciarSesion(
          'usuario@prueba.com',
          '123456',
        ),
        throwsA(
          predicate(
            (error) => error.toString().contains(
                  'datos esperados',
                ),
          ),
        ),
      );
    },
  );

  test(
    'Cerrar sesión debe eliminar el token almacenado',
    () async {
      final storage = FakeSecureStorage();
      final preferences = FakePreferences();

      AuthService.configurarAlmacenamientoParaPruebas(
        storage,
      );

      AuthService.configurarPreferenciasParaPruebas(
        preferences,
      );

      await storage.write(
        key: 'token',
        value: 'token-prueba',
      );

      expect(
        await AuthService.obtenerToken(),
        'token-prueba',
      );

      await ApiService.cerrarSesion();

      expect(
        await AuthService.obtenerToken(),
        isNull,
      );
    },
  );
}

