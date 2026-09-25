import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SecureStorageAdapter {
  Future<void> write({
    required String key,
    required String value,
  });

  Future<String?> read({
    required String key,
  });

  Future<void> delete({
    required String key,
  });
}

class FlutterSecureStorageAdapter implements SecureStorageAdapter {
  final FlutterSecureStorage _storage;

  FlutterSecureStorageAdapter({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> write({
    required String key,
    required String value,
  }) async {
    await _storage.write(
      key: key,
      value: value,
    );
  }

  @override
  Future<String?> read({
    required String key,
  }) async {
    return await _storage.read(
      key: key,
    );
  }

  @override
  Future<void> delete({
    required String key,
  }) async {
    await _storage.delete(
      key: key,
    );
  }
}

abstract class PreferencesAdapter {
  Future<void> setString(
    String key,
    String value,
  );

  String? getString(
    String key,
  );

  Future<void> remove(
    String key,
  );
}

class SharedPreferencesAdapter implements PreferencesAdapter {
  final SharedPreferences _preferences;

  SharedPreferencesAdapter(this._preferences);

  @override
  Future<void> setString(
    String key,
    String value,
  ) async {
    await _preferences.setString(
      key,
      value,
    );
  }

  @override
  String? getString(
    String key,
  ) {
    return _preferences.getString(key);
  }

  @override
  Future<void> remove(
    String key,
  ) async {
    await _preferences.remove(key);
  }
}

class AuthService {
  static const String _tokenKey = 'token';
  static const String _nombreKey = 'usuario_nombre';
  static const String _correoKey = 'usuario_correo';

  static SecureStorageAdapter _secureStorage =
      FlutterSecureStorageAdapter();

  static PreferencesAdapter? _preferences;

  static Future<PreferencesAdapter> _obtenerPreferences() async {
    if (_preferences != null) {
      return _preferences!;
    }

    final prefs = await SharedPreferences.getInstance();

    _preferences = SharedPreferencesAdapter(prefs);

    return _preferences!;
  }

  static void configurarAlmacenamientoParaPruebas(
    SecureStorageAdapter storage,
  ) {
    _secureStorage = storage;
  }

  static void configurarPreferenciasParaPruebas(
    PreferencesAdapter preferences,
  ) {
    _preferences = preferences;
  }

  static void restaurarAlmacenamientoReal() {
    _secureStorage = FlutterSecureStorageAdapter();
    _preferences = null;
  }

  static Future<void> guardarSesion({
    required String token,
    required String nombre,
    required String correo,
  }) async {
    await _secureStorage.write(
      key: _tokenKey,
      value: token,
    );

    final prefs = await _obtenerPreferences();

    await prefs.setString(
      _nombreKey,
      nombre,
    );

    await prefs.setString(
      _correoKey,
      correo,
    );
  }

  static Future<String?> obtenerToken() async {
    return await _secureStorage.read(
      key: _tokenKey,
    );
  }

  static Future<String?> obtenerNombre() async {
    final prefs = await _obtenerPreferences();

    return prefs.getString(_nombreKey);
  }

  static Future<String?> obtenerCorreo() async {
    final prefs = await _obtenerPreferences();

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

    final prefs = await _obtenerPreferences();

    await prefs.remove(_nombreKey);
    await prefs.remove(_correoKey);
  }
}

