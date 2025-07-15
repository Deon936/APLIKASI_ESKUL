import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final String username;

  const SettingsScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pengaturan")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Halo $username!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text("Ganti Password"),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fitur belum tersedia")));
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("Tentang Aplikasi"),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: "Aplikasi Ekstrakurikuler",
                  applicationVersion: "1.0.0",
                  children: [Text("Dikembangkan dengan Flutter + SQLite.")],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
