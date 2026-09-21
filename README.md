# EmprendePLUS

Aplicación móvil multiplataforma desarrollada con Flutter para el proyecto integrador EmprendePLUS.

## 1. Framework seleccionado

Se seleccionó Flutter como framework multiplataforma porque permite desarrollar una aplicación para Android e iOS utilizando una misma base de código. Además, facilita el desarrollo, las pruebas y la recarga en caliente durante la construcción de la aplicación.

## 2. Entorno de desarrollo

- Flutter 3.47.0
- Dart 3.13.0
- Android SDK 36.0.0
- Android Studio
- Visual Studio Code
- Node.js
- Express
- Prisma
- MySQL

## 3. Verificación del entorno

El entorno fue verificado mediante el siguiente comando:

```bash
flutter doctor

[√] Flutter
[√] Windows Version
[√] Android toolchain
[√] Chrome
[√] Visual Studio
[√] Connected device
[√] Network resources

No issues found!

flutter --version

Flutter 3.47.0
Dart 3.13.0
DevTools 2.60.0

flutter devices

lib/
├── models/
├── screens/
├── services/
└── widgets/

API_URL=http://10.0.2.2:3000


npm run dev

POST /usuarios/login

flutter pub get

flutter analyze

No issues found!

flutter run


