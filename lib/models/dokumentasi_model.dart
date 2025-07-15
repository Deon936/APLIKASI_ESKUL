import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../database/db_helper.dart';

class DokumentasiScreen extends StatefulWidget {
  final String username;
  const DokumentasiScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<DokumentasiScreen> createState() => _DokumentasiScreenState();
}

class _DokumentasiScreenState extends State<DokumentasiScreen> {
  final DBHelper dbHelper = DBHelper();
  List<Map<String, dynamic>> dokumentasiList = [];

  @override
  void initState() {
    super.initState();
    fetchDokumentasi();
  }

  Future<void> fetchDokumentasi() async {
    final data = await dbHelper.getDokumentasiByUser(widget.username);
    setState(() => dokumentasiList = data);
  }

  Future<void> tambahDokumentasi() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final captionController = TextEditingController();

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Tambah Dokumentasi"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.file(File(image.path), height: 150),
              const SizedBox(height: 10),
              TextField(
                controller: captionController,
                decoration: const InputDecoration(labelText: "Caption"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await dbHelper.insertDokumentasi({
                  'username': widget.username,
                  'imagePath': image.path,
                  'caption': captionController.text,
                });
                Navigator.pop(context);
                fetchDokumentasi();
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> hapusDokumentasi(int id) async {
    await dbHelper.deleteDokumentasi(id);
    fetchDokumentasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dokumentasi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: tambahDokumentasi,
          ),
        ],
      ),
      body: dokumentasiList.isEmpty
          ? const Center(child: Text("Belum ada dokumentasi."))
          : ListView.builder(
              itemCount: dokumentasiList.length,
              itemBuilder: (_, i) {
                final item = dokumentasiList[i];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.file(File(item['imagePath']), width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(item['caption']),
                    subtitle: Text("Oleh: ${item['username']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => hapusDokumentasi(item['id']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
