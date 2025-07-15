class Biodata {
  final int? id;
  final String namaLengkap;
  final String namaPanggilan;
  final String tempatTanggalLahir;
  final double tinggiBadan;
  final double beratBadan;
  final String hasilTes;
  final String alasan;

  Biodata({
    this.id,
    required this.namaLengkap,
    required this.namaPanggilan,
    required this.tempatTanggalLahir,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.hasilTes,
    required this.alasan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaLengkap': namaLengkap,
      'namaPanggilan': namaPanggilan,
      'tempatTanggalLahir': tempatTanggalLahir,
      'tinggiBadan': tinggiBadan,
      'beratBadan': beratBadan,
      'hasilTes': hasilTes,
      'alasan': alasan,
    };
  }
}
