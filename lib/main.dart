import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Import layar
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/biodata_screen.dart';
import 'screens/ekstrakurikuler_screen.dart';
import 'screens/absensi_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ❗ Hapus database lama untuk testing ulang struktur tabel (opsional di produksi)
  final dbPath = await getDatabasesPath();
  await deleteDatabase(join(dbPath, 'ekskul_app.db'));

  runApp(const EkskulApp());
}

class EkskulApp extends StatelessWidget {
  const EkskulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Ekstrakurikuler',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/biodata': (context) => const LengkapiDataDiriScreen(username: ''),
        '/eskul': (context) => const EkstrakurikulerScreen(username: ''),
        '/absensi': (context) => const AbsensiScreen(username: ''),
        // Route dinamis: profile
        '/profile': (context) {
          final username = ModalRoute.of(context)!.settings.arguments as String;
          return ProfileScreen(username: username);
        },
      },
    );
  }
}
