import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings: settings,
    );
  }

  static Future<bool> solicitarPermiso() async {
    final androidImplementation =
        _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    final concedido =
        await androidImplementation?.requestNotificationsPermission();

    return concedido ?? false;
  }

  static Future<void> mostrarNotificacion({
    required int id,
    required String titulo,
    required String mensaje,
  }) async {
    const detallesAndroid = AndroidNotificationDetails(
      'emprendeplus_general',
      'Notificaciones de EmprendePLUS',
      channelDescription:
          'Notificaciones relacionadas con la gestión del negocio.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const detalles = NotificationDetails(
      android: detallesAndroid,
    );

    await _notifications.show(
      id: id,
      title: titulo,
      body: mensaje,
      notificationDetails: detalles,
    );
  }
}