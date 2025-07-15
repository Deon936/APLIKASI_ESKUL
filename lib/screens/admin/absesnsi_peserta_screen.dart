// screens/admin/absensi_peserta_screen.dart
import 'package:flutter/material.dart';
import '../../database/db_helper.dart';

class AbsensiPesertaScreen extends StatelessWidget {
  final DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absensi Peserta')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.database.then((db) => db.query('absensi')),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text('Belum ada data absensi'));

          return ListView(
            children: snapshot.data!.map((absen) {
              return ListTile(
                title: Text(absen['username']),
                subtitle: Text('${absen['tanggal']} - ${absen['status']}'),
                trailing: Text(absen['keterangan'] ?? '-'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
