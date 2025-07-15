import 'package:flutter/material.dart';
import 'package:sekolah/models/dokumentasi_model.dart';
import 'package:sekolah/screens/absensi_screen.dart';
import 'package:sekolah/screens/admin/cetak_laporan_screen.dart';
import 'package:sekolah/screens/admin/data_peserta_screen.dart';
import 'package:sekolah/screens/admin/input_nilai_screen.dart';
import 'package:sekolah/screens/admin/absesnsi_peserta_screen.dart';
import 'package:sekolah/screens/biodata_screen.dart';
import 'package:sekolah/screens/ekstrakurikuler_screen.dart';
import 'package:sekolah/screens/nilai_screen.dart';
import 'package:sekolah/screens/profile_screen.dart';
import 'package:sekolah/screens/seiings_screen.dart';
import 'package:sekolah/screens/settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String username;
  final String role;

  const DashboardScreen({Key? key, required this.username, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard - ${role.toUpperCase()}'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.account_circle, size: 60, color: Colors.white),
                  SizedBox(height: 8),
                  Text(username, style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text(role.toUpperCase(), style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.person),
              title: Text("Lihat Profil"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile', arguments: username);
              },
            ),

            if (role == 'admin' || role == 'instruktur') ...[
              ListTile(
                leading: Icon(Icons.group),
                title: Text("Data Peserta"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DataPesertaScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.checklist),
                title: Text("Absensi Peserta"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AbsensiPesertaScreen()));
                },
              ),
              ListTile(
                leading: Icon(Icons.edit_note),
                title: Text("Input Penilaian"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PenilaianScreen(username: username)));
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Dokumentasi"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DokumentasiScreen(username: username)));
                },
              ),
              ListTile(
                leading: Icon(Icons.print),
                title: Text("Cetak Laporan"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CetakLaporanScreen()));
                },
              ),
            ],

            if (role == 'siswa') ...[
              ListTile(
                leading: Icon(Icons.list),
                title: Text("Pemilihan Ekskul"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => EkstrakurikulerScreen(username: username)));
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Biodata"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LengkapiDataDiriScreen(username: username)));
                },
              ),
              ListTile(
                leading: Icon(Icons.check_circle_outline),
                title: Text("Absen"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AbsensiScreen(username: username)));
                },
              ),
              ListTile(
                leading: Icon(Icons.grade),
                title: Text("Lihat Nilai"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LihatNilaiScreen(username: username)));
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_album),
                title: Text("Dokumentasi"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DokumentasiScreen(username: username)));
                },
              ),
            ],

            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Pengaturan"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(username: username)));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang, $username!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (role == 'siswa') ..._siswaMenu(context),
            if (role == 'admin' || role == 'instruktur') ..._adminInstrukturMenu(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _siswaMenu(BuildContext context) {
    return [
      _menuButton(context, "Pemilihan Ekstrakurikuler", Icons.list, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => EkstrakurikulerScreen(username: username)));
      }),
      _menuButton(context, "Biodata", Icons.person, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LengkapiDataDiriScreen(username: username)));
      }),
      _menuButton(context, "Absen", Icons.check_circle_outline, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AbsensiScreen(username: username)));
      }),
      _menuButton(context, "Lihat nilai", Icons.grade, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LihatNilaiScreen(username: username)));
      }),
      _menuButton(context, "Dokumentasi", Icons.photo_album, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DokumentasiScreen(username: username)));
      }),
    ];
  }

  List<Widget> _adminInstrukturMenu(BuildContext context) {
    return [
      _menuButton(context, "Data Peserta", Icons.group, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DataPesertaScreen()));
      }),
      _menuButton(context, "Absensi Peserta", Icons.checklist, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => AbsensiPesertaScreen()));
      }),
      _menuButton(context, "Input Penilaian", Icons.edit_note, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => PenilaianScreen(username: username)));
      }),
      _menuButton(context, "Dokumentasi", Icons.image, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DokumentasiScreen(username: username)));
      }),
      _menuButton(context, "Cetak Laporan", Icons.print, () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => CetakLaporanScreen()));
      }),
    ];
  }

  Widget _menuButton(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
