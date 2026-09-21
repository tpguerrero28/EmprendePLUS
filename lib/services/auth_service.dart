import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _nombreKey = 'usuario_nombre';
  static const String _correoKey = 'usuario_correo';

  static const FlutterSecureStorage _secureStorage =
      FlutterSecureStorage();

  static Future<void> guardarSesion({
    required String token,
    required String nombre,
    required String correo,
  }) async {
    await _secureStorage.write(
      key: _tokenKey,
      value: token,
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_nombreKey, nombre);
    await prefs.setString(_correoKey, correo);
  }

  static Future<String?> obtenerToken() async {
    return await _secureStorage.read(
      key: _tokenKey,
    );
  }

  static Future<String?> obtenerNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nombreKey);
  }

  static Future<String?> obtenerCorreo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_correoKey);
  }

  static Future<bool> estaAutenticado() async {
    final token = await obtenerToken();

    return token != null && token.isNotEmpty;
  }

  static Future<void> cerrarSesion() async {
    await _secureStorage.delete(
      key: _tokenKey,
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_nombreKey);
    await prefs.remove(_correoKey);
  }
}