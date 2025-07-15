import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';   
import 'package:printing/printing.dart';
import '../../database/db_helper.dart';

class CetakLaporanScreen extends StatefulWidget {
  const CetakLaporanScreen({super.key});

  @override
  State<CetakLaporanScreen> createState() => _CetakLaporanScreenState();
}

class _CetakLaporanScreenState extends State<CetakLaporanScreen> {
  final DBHelper dbHelper = DBHelper();
  late Future<List<Map<String, dynamic>>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = dbHelper.getAllBiodata();
  }

  /* =========================
     Generate PDF
  ========================= */
  Future<pw.Document> _buildPdf(List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text('LAPORAN DATA PESERTA', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 12),

          // Tabel
          pw.Table.fromTextArray(
            headerDecoration: pw.BoxDecoration(color: PdfColor.fromInt(0xffe0e0e0)),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headers: [
              'No', 'NIS', 'Nama', 'Kelas', 'No HP', 'Email'
            ],
            data: List.generate(data.length, (i) {
              final p = data[i];
              return [
                (i + 1).toString(),
                p['nis'] ?? '-',
                p['namaLengkap'] ?? '-',
                p['kelas'] ?? '-',
                p['noHp'] ?? '-',
                p['email'] ?? '-',
              ];
            }),
            cellAlignment: pw.Alignment.centerLeft,
            cellHeight: 20,
            columnWidths: {
              0: const pw.FixedColumnWidth(25),
              1: const pw.FixedColumnWidth(50),
              3: const pw.FixedColumnWidth(40),
            },
          ),
        ],
      ),
    );
    return pdf;
  }

  /* =========================
     Export & Print PDF
  ========================= */
  Future<void> _exportPdf() async {
    final data = await dbHelper.getAllBiodata();
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak ada data untuk dicetak')));
      return;
    }
    final doc = await _buildPdf(data);
    await Printing.layoutPdf(onLayout: (format) => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cetak Laporan')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportPdf,
        icon: const Icon(Icons.print),
        label: const Text('Export PDF'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data peserta'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final p = data[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['namaLengkap'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('NIS   : ${p['nis'] ?? '-'}'),
                      Text('Kelas : ${p['kelas'] ?? '-'}'),
                      Text('No HP : ${p['noHp'] ?? '-'}'),
                      Text('Email : ${p['email'] ?? '-'}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
