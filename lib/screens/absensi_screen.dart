import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/absensi_model.dart';
import 'package:intl/intl.dart';

class AbsensiScreen extends StatefulWidget {
  final String username;

  const AbsensiScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<AbsensiScreen> createState() => _AbsensiScreenState();
}

class _AbsensiScreenState extends State<AbsensiScreen> {
  final DBHelper dbHelper = DBHelper();
  String? selectedStatus;
  final TextEditingController keteranganController = TextEditingController();

  void _simpanAbsensi() async {
    if (selectedStatus == null) {
      _showMessage("Pilih status kehadiran terlebih dahulu.");
      return;
    }

    final tanggal = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final absensi = AbsensiModel(
      username: widget.username,
      tanggal: tanggal,
      status: selectedStatus!,
      keterangan: keteranganController.text,
    );

    final db = await dbHelper.database;
    await db.insert('absensi', absensi.toMap());

    _showMessage("Absensi berhasil disimpan.");
    setState(() {
      selectedStatus = null;
      keteranganController.clear();
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Absensi Siswa")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Status Kehadiran",
                border: OutlineInputBorder(),
              ),
              value: selectedStatus,
              items: ["Hadir", "Sakit", "Izin", "Alfa"].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (val) => setState(() => selectedStatus = val),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: keteranganController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Keterangan (opsional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Simpan Absensi"),
                onPressed: _simpanAbsensi,
              ),
            )
          ],
        ),
      ),
    );
  }
}
