import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  String selectedRole = 'siswa'; 
  final DBHelper dbHelper = DBHelper();

  void _register() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username & Password tidak boleh kosong")),
      );
      return;
    }

    if (nisController.text.trim().isEmpty ||
        namaLengkapController.text.trim().isEmpty ||
        kelasController.text.trim().isEmpty ||
        noHpController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        alamatController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lengkapi semua data")),
      );
      return;
    }

    // Simpan ke tabel users
    await dbHelper.registerUser(username, password, selectedRole);

    // Simpan ke tabel biodata
    await dbHelper.insertBiodata({
      'username': username,
      'nis': nisController.text.trim(),
      'namaLengkap': namaLengkapController.text.trim(),
      'kelas': kelasController.text.trim(),
      'noHp': noHpController.text.trim(),
      'email': emailController.text.trim(),
      'alamat': alamatController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Berhasil Daftar")),
    );
    Navigator.pop(context); // kembali ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi Akun")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.person_add_alt_1, size: 80, color: Colors.green),
            const SizedBox(height: 20),

            // Username
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Role
            DropdownButtonFormField<String>(
              value: selectedRole,
              items: ['siswa', 'instruktur']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => selectedRole = value);
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.account_box),
                labelText: 'Pilih Role',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // NIS
            TextField(
              controller: nisController,
              decoration: const InputDecoration(
                labelText: 'NIS',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Nama Lengkap
            TextField(
              controller: namaLengkapController,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Kelas
            TextField(
              controller: kelasController,
              decoration: const InputDecoration(
                labelText: 'Kelas',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // No HP
            TextField(
              controller: noHpController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'No. HP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Alamat
            TextField(
              controller: alamatController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Tombol Daftar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _register,
                icon: const Icon(Icons.app_registration),
                label: const Text("Daftar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
