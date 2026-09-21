import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',

  redirect: (BuildContext context, GoRouterState state) async {
    final estaAutenticado = await AuthService.estaAutenticado();

    final estaEnLogin = state.matchedLocation == '/login';

    if (!estaAutenticado && !estaEnLogin) {
      return '/login';
    }

    if (estaAutenticado && estaEnLogin) {
      return '/inicio';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: '/inicio',
      name: 'inicio',
      builder: (context, state) => FutureBuilder(
        future: Future.wait([
          AuthService.obtenerNombre(),
          AuthService.obtenerCorreo(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final datos = snapshot.data;

          final nombre = datos?[0] ?? 'Usuario';
          final correo = datos?[1] ?? '';

          return HomeScreen(
            nombre: nombre,
            correo: correo,
          );
        },
      ),
    ),
  ],
);