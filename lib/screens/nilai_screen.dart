import 'package:flutter/material.dart';
import 'package:sekolah/database/db_helper.dart';
import '../database/db_helper.dart';

class LihatNilaiScreen extends StatefulWidget {
  final String username;
  const LihatNilaiScreen({super.key, required this.username});

  @override
  State<LihatNilaiScreen> createState() => _LihatNilaiScreenState();
}

class _LihatNilaiScreenState extends State<LihatNilaiScreen> {
  final DBHelper dbHelper = DBHelper();
  List<Map<String, dynamic>> penilaianList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final data = await dbHelper.getPenilaianByUser(widget.username);
    setState(() {
      penilaianList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nilai & Penilaian")),
      body: penilaianList.isEmpty
          ? const Center(child: Text("Belum ada penilaian"))
          : ListView.builder(
              itemCount: penilaianList.length,
              itemBuilder: (context, index) {
                final item = penilaianList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(Icons.grade, color: Colors.indigo),
                    title: Text("Tanggal: ${item['tanggal']}"),
                    subtitle: Text("Nilai: ${item['nilai']}\nCatatan: ${item['catatan']}"),
                  ),
                );
              },
            ),
    );
  }
}
