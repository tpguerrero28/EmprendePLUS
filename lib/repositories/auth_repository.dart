import '../models/usuario.dart';
import '../services/api_service.dart';

class AuthRepository {
  Future<Usuario> iniciarSesion(
    String correo,
    String contrasena,
  ) async {
    return await ApiService.iniciarSesion(
      correo,
      contrasena,
    );
  }

  Future<void> cerrarSesion() async {
    await ApiService.cerrarSesion();
  }
}