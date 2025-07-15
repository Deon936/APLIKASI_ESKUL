import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class EkstrakurikulerScreen extends StatefulWidget {
  final String username;       // kirim dari Dashboard
  const EkstrakurikulerScreen({Key? key, required this.username})
      : super(key: key);

  @override
  State<EkstrakurikulerScreen> createState() => _EkstrakurikulerScreenState();
}

class _EkstrakurikulerScreenState extends State<EkstrakurikulerScreen> {
  final dbHelper = DBHelper();

  // Struktur: kategori → list cabang
  final Map<String, List<String>> _data = {
    'Olahraga': ['Sepakbola', 'Futsal', 'Voli', 'Bulu Tangkis'],
    'Bahasa': ['English Club', 'Korean Club', 'Japanese Club', 'Arabic Club'],
    'Seni': ['Drumband', 'Tari', 'Paduan Suara'],
    'Kebangsaan': ['Paskibraka', 'Pramuka'],
    'Teknologi': ['Informatika Club'],
  };

  String? _selectedKategori;          // step 1
  String? _selectedEkskul;            // step 2

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Ekstrakurikuler')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ----- Langkah 1: pilih kategori -----
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: _data.keys
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              value: _selectedKategori,
              onChanged: (val) {
                setState(() {
                  _selectedKategori = val;
                  _selectedEkskul = null; // reset cabang
                });
              },
            ),
            const SizedBox(height: 20),

            // ----- Langkah 2: pilih cabang (muncul setelah kategori dipilih) -----
            if (_selectedKategori != null)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Cabang Ekstrakurikuler',
                  border: OutlineInputBorder(),
                ),
                items: _data[_selectedKategori]!
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                value: _selectedEkskul,
                onChanged: (val) {
                  setState(() => _selectedEkskul = val);
                },
              ),

            const Spacer(),

            // ----- Tombol Simpan -----
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Simpan Pilihan'),
              onPressed: _selectedEkskul == null ? null : _simpanPilihan,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _simpanPilihan() async {
    await dbHelper.insertPilihanEkskul(
      username: widget.username,
      ekskul: _selectedEkskul!,
      kategori: _selectedKategori!,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pilihan $_selectedEkskul tersimpan!')),
    );
    Navigator.pop(context); // balik ke Dashboard
  }
}
