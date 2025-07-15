class AbsensiModel {
  final int? id;
  final String username;
  final String tanggal;
  final String status; // Hadir, Sakit, Izin, Alfa
  final String? keterangan;

  AbsensiModel({
    this.id,
    required this.username,
    required this.tanggal,
    required this.status,
    this.keterangan,
  });

  // Konversi dari Map ke Objek AbsensiModel
  factory AbsensiModel.fromMap(Map<String, dynamic> map) {
    return AbsensiModel(
      id: map['id'],
      username: map['username'],
      tanggal: map['tanggal'],
      status: map['status'],
      keterangan: map['keterangan'],
    );
  }

  // Konversi dari Objek ke Map untuk SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'tanggal': tanggal,
      'status': status,
      'keterangan': keterangan,
    };
  }
}
