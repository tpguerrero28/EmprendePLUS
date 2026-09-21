import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<String> obtenerUbicacion() async {
    // 1. Verificar si el servicio de ubicación está activado.
    final servicioActivo =
        await Geolocator.isLocationServiceEnabled();

    if (!servicioActivo) {
      return 'El servicio de ubicación está desactivado.';
    }

    // 2. Consultar el permiso actual.
    LocationPermission permiso =
        await Geolocator.checkPermission();

    // 3. Solicitar permiso si todavía no se ha solicitado.
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    // 4. Permiso denegado.
    if (permiso == LocationPermission.denied) {
      return 'Permiso de ubicación denegado.';
    }

    // 5. Denegación permanente.
    if (permiso == LocationPermission.deniedForever) {
      return 'Permiso de ubicación denegado permanentemente. '
          'Debe habilitarlo desde los ajustes del sistema.';
    }

    // 6. Obtener la ubicación actual.
    final posicion = await Geolocator.getCurrentPosition();

    return 'Latitud: ${posicion.latitude}\n'
        'Longitud: ${posicion.longitude}';
  }

  static Future<void> abrirAjustes() async {
    await Geolocator.openAppSettings();
  }
}