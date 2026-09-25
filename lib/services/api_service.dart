import 'package:dio/dio.dart';
import '../models/usuario.dart';
import 'auth_service.dart';
import 'dio_client.dart';

class ApiService {
  static Dio _dio = DioClient.dio;

  static void configurarDioParaPruebas(Dio dio) {
    _dio = dio;
  }

  static void restaurarDioReal() {
    _dio = DioClient.dio;
  }

  static Future<Usuario> iniciarSesion(
    String correo,
    String contrasena,
  ) async {
    try {
      final response = await _dio.post(
        '/usuarios/login',
        data: {
          'correo': correo,
          'contraseña': contrasena,
        },
      );

      if (response.statusCode == 200) {
        final resultado =
            Map<String, dynamic>.from(response.data);

        final token = resultado['token'];
        final usuarioJson = resultado['usuario'];

        if (token == null || usuarioJson == null) {
          throw Exception(
            'La respuesta del servidor no contiene los datos esperados.',
          );
        }

        final usuario = Usuario.fromJson(
          Map<String, dynamic>.from(usuarioJson),
        );

        await AuthService.guardarSesion(
          token: token.toString(),
          nombre: usuario.nombre,
          correo: usuario.correo,
        );

        return usuario;
      }

      throw Exception(
        'Error al iniciar sesión. Código: ${response.statusCode}',
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw Exception(
          'Correo o contraseña incorrectos.',
        );
      }

      if (error.response?.statusCode == 403) {
        throw Exception(
          'No tiene permisos para realizar esta acción.',
        );
      }

      throw Exception(
        'No se pudo conectar con el servidor.',
      );
    }
  }

  static Future<void> cerrarSesion() async {
    await AuthService.cerrarSesion();
  }
}