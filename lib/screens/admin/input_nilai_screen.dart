import 'package:flutter/material.dart';
import '../../database/db_helper.dart';

class PenilaianScreen extends StatefulWidget {
  final String username;
  const PenilaianScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<PenilaianScreen> createState() => _PenilaianScreenState();
}

class _PenilaianScreenState extends State<PenilaianScreen> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController _penilaianController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  List<Map<String, dynamic>> _penilaianList = [];

  @override
  void initState() {
    super.initState();
    _loadPenilaian();
  }

  void _loadPenilaian() async {
    final db = await dbHelper.database;
    final data = await db.query('penilaian',
        where: 'username = ?', whereArgs: [widget.username]);
    setState(() {
      _penilaianList = data;
    });
  }

  void _simpanPenilaian() async {
    if (_penilaianController.text.isEmpty) return;
    final db = await dbHelper.database;
    await db.insert('penilaian', {
      'username': widget.username,
      'tanggal': DateTime.now().toIso8601String(),
      'nilai': _penilaianController.text,
      'catatan': _catatanController.text,
    });
    _penilaianController.clear();
    _catatanController.clear();
    _loadPenilaian();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Penilaian disimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Penilaian & Nilai")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _penilaianController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Nilai (0-100)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _catatanController,
              decoration: const InputDecoration(
                labelText: "Catatan / Komentar",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _simpanPenilaian,
              child: const Text("Simpan"),
            ),
            const SizedBox(height: 24),
            const Text("Riwayat Penilaian", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _penilaianList.length,
                itemBuilder: (context, index) {
                  final item = _penilaianList[index];
                  return Card(
                    child: ListTile(
                      title: Text("Nilai: ${item['nilai']}", style: const TextStyle(fontSize: 16)),
                      subtitle: Text("Catatan: ${item['catatan'] ?? '-'}\nTanggal: ${item['tanggal'].toString().substring(0, 10)}"),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
