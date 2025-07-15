import 'package:flutter/material.dart';
import '../../database/db_helper.dart';

class DataPesertaScreen extends StatelessWidget {
  final DBHelper dbHelper = DBHelper();

  DataPesertaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Peserta'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getAllBiodata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada peserta'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final peserta = data[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  title: Text(peserta['namaLengkap'] ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NIS     : ${peserta['nis'] ?? '-'}'),
                      Text('Kelas   : ${peserta['kelas'] ?? '-'}'),
                      Text('No HP   : ${peserta['noHp'] ?? '-'}'),
                      Text('Email   : ${peserta['email'] ?? '-'}'),
                      Text('Alamat  : ${peserta['alamat'] ?? '-'}'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
