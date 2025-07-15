import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final dbHelper = DBHelper();
  Map<String, dynamic>? _biodata;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final data = await dbHelper.getBiodataByUsername(widget.username);
    if (data != null) {
      setState(() => _biodata = data);
    }
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? '-')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya")),
      body: _biodata == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Data Pribadi",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(),
                      _infoRow("NIS", _biodata!['nis']),
                      _infoRow("Nama Lengkap", _biodata!['namaLengkap']),
                      _infoRow("Kelas", _biodata!['kelas']),
                      _infoRow("No HP", _biodata!['noHp']),
                      _infoRow("Email", _biodata!['email']),
                      _infoRow("Alamat", _biodata!['alamat']),
                      _infoRow("Nama Panggilan", _biodata!['namaPanggilan']),
                      _infoRow("Tempat, Tanggal Lahir", _biodata!['tempatTanggalLahir']),
                      _infoRow("Tinggi Badan", "${_biodata!['tinggiBadan']} cm"),
                      _infoRow("Berat Badan", "${_biodata!['beratBadan']} kg"),
                      _infoRow("Hasil Tes Bakat", _biodata!['hasilTes']),
                      _infoRow("Alasan Ekskul", _biodata!['alasan']),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
  