import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class LengkapiDataDiriScreen extends StatefulWidget {
  final String username;

  const LengkapiDataDiriScreen({super.key, required this.username});

  @override
  State<LengkapiDataDiriScreen> createState() => _LengkapiDataDiriScreenState();
}

class _LengkapiDataDiriScreenState extends State<LengkapiDataDiriScreen> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DBHelper();

  // Data dari register (tampil saja)
  String nis = '';
  String namaLengkap = '';
  String kelas = '';
  String noHp = '';
  String email = '';
  String alamat = '';

  // Form pelengkap
  final TextEditingController _namaPanggilan = TextEditingController();
  final TextEditingController _ttl = TextEditingController();
  final TextEditingController _tinggi = TextEditingController();
  final TextEditingController _berat = TextEditingController();
  final TextEditingController _hasilTes = TextEditingController();
  final TextEditingController _alasan = TextEditingController();

  int? biodataId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await dbHelper.getBiodataByUsername(widget.username);
    if (data != null) {
      setState(() {
        biodataId = data['id'];

        // Data dari register
        nis = data['nis'] ?? '';
        namaLengkap = data['namaLengkap'] ?? '';
        kelas = data['kelas'] ?? '';
        noHp = data['noHp'] ?? '';
        email = data['email'] ?? '';
        alamat = data['alamat'] ?? '';

        // Data pelengkap (optional)
        _namaPanggilan.text = data['namaPanggilan'] ?? '';
        _ttl.text = data['tempatTanggalLahir'] ?? '';
        _tinggi.text = (data['tinggiBadan'] ?? '').toString();
        _berat.text = (data['beratBadan'] ?? '').toString();
        _hasilTes.text = data['hasilTes'] ?? '';
        _alasan.text = data['alasan'] ?? '';
      });
    }
  }

  void _simpan() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'username': widget.username,
        'nis': nis,
        'namaLengkap': namaLengkap,
        'kelas': kelas,
        'noHp': noHp,
        'email': email,
        'alamat': alamat,
        'namaPanggilan': _namaPanggilan.text,
        'tempatTanggalLahir': _ttl.text,
        'tinggiBadan': double.tryParse(_tinggi.text) ?? 0,
        'beratBadan': double.tryParse(_berat.text) ?? 0,
        'hasilTes': _hasilTes.text,
        'alasan': _alasan.text,
      };

      if (biodataId != null) {
        await dbHelper.updateBiodata(biodataId!, data);
      } else {
        await dbHelper.insertBiodata(data);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data berhasil disimpan")),
      );
      Navigator.pop(context);
    }
  }

  Widget _cardDataRegister() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text("NIS: $nis"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Lengkap: $namaLengkap"),
            Text("Kelas: $kelas"),
            Text("No HP: $noHp"),
            Text("Email: $email"),
            Text("Alamat: $alamat"),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lengkapi Data Diri")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _cardDataRegister(),
              const Text("Form Lengkapi Data",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _field("Nama Panggilan", _namaPanggilan),
              _field("Tempat, Tanggal Lahir", _ttl),
              _field("Tinggi Badan (cm)", _tinggi, TextInputType.number),
              _field("Berat Badan (kg)", _berat, TextInputType.number),
              _field("Hasil Tes Bakat Minat", _hasilTes),
              _field("Alasan Mengikuti Ekskul", _alasan,
                  TextInputType.text, 3),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _simpan,
                  icon: Icon(Icons.save),
                  label: Text("Simpan"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      [TextInputType type = TextInputType.text, int maxLines = 1]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }
}
