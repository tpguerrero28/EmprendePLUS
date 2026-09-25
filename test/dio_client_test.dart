import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

Dio crearDioDouble({
  required int statusCode,
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
  test(
    'Double HTTP debe simular una respuesta 200',
    () async {
      final dio = crearDioDouble(
        statusCode: 200,
        data: {
          'mensaje': 'Solicitud exitosa',
        },
      );

      final response = await dio.get('/prueba');

      expect(response.statusCode, 200);
      expect(
        response.data['mensaje'],
        'Solicitud exitosa',
      );
    },
  );

  test(
    'Double HTTP debe simular una respuesta 401',
    () async {
      final dio = crearDioDouble(
        statusCode: 401,
        data: {
          'mensaje': 'Token expirado',
        },
      );

      expect(
        () => dio.get('/prueba'),
        throwsA(
          isA<DioException>().having(
            (error) => error.response?.statusCode,
            'statusCode',
            401,
          ),
        ),
      );
    },
  );

  test(
    'Double HTTP debe simular una respuesta 422',
    () async {
      final dio = crearDioDouble(
        statusCode: 422,
        data: {
          'mensaje': 'Datos inválidos',
          'errores': {
            'correo': 'El correo no es válido',
          },
        },
      );

      expect(
        () => dio.post(
          '/prueba',
          data: {
            'correo': 'correo-invalido',
          },
        ),
        throwsA(
          isA<DioException>().having(
            (error) => error.response?.statusCode,
            'statusCode',
            422,
          ),
        ),
      );
    },
  );

  test(
    'Double HTTP debe simular un timeout',
    () async {
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://servidor-prueba.local',
        ),
      );

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionTimeout,
              ),
            );
          },
        ),
      );

      expect(
        () => dio.get('/prueba'),
        throwsA(
          isA<DioException>().having(
            (error) => error.type,
            'tipo',
            DioExceptionType.connectionTimeout,
          ),
        ),
      );
    },
  );

  test(
    '401 debe renovar el token y repetir la solicitud',
    () async {
      var cantidadSolicitudes = 0;
      var tokenActual = 'token-expirado';

      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://servidor-prueba.local',
        ),
      );

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            cantidadSolicitudes++;

            if (cantidadSolicitudes == 1) {
              handler.reject(
                DioException(
                  requestOptions: options,
                  response: Response(
                    requestOptions: options,
                    statusCode: 401,
                  ),
                ),
              );
              return;
            }

            options.headers['Authorization'] =
                'Bearer $tokenActual';

            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'mensaje':
                      'Solicitud realizada con token renovado',
                },
              ),
            );
          },
        ),
      );

      try {
        await dio.get(
          '/prueba',
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenActual',
            },
          ),
        );
      } on DioException catch (error) {
        expect(
          error.response?.statusCode,
          401,
        );

        tokenActual = 'token-renovado';

        final respuesta = await dio.get(
          '/prueba',
          options: Options(
            headers: {
              'Authorization': 'Bearer $tokenActual',
            },
          ),
        );

        expect(
          respuesta.statusCode,
          200,
        );

        expect(
          respuesta.data['mensaje'],
          'Solicitud realizada con token renovado',
        );

        expect(
          cantidadSolicitudes,
          2,
        );

        expect(
          respuesta.requestOptions.headers['Authorization'],
          'Bearer token-renovado',
        );
      }
    },
  );
}