class Quran {
  final int? nomor;
  final String? nama;
  final String? namaLatin;
  final int? jumlahAyat;
  final String? tempatTurun;
  final String? arti;
  final String? deskripsi;
  final AudioFull? audioFull;

  Quran(
      {this.nomor,
      this.nama,
      this.namaLatin,
      this.jumlahAyat,
      this.tempatTurun,
      this.arti,
      this.deskripsi,
      this.audioFull});

  factory Quran.fromJson(Map<String, dynamic> json) {
    return Quran(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      jumlahAyat: json['jumlahAyat'],
      tempatTurun: json['tempatTurun'],
      arti: json['arti'],
      deskripsi: json['deskripsi'],
      audioFull: json['audioFull'] != null
          ? AudioFull.fromJson(json['audioFull'])
          : null,
    );
  }
}

class AudioFull {
  final String? s01;
  final String? s02;
  final String? s03;
  final String? s04;
  final String? s05;
  final List<String>? audioList;

  AudioFull({this.s01, this.s02, this.s03, this.s04, this.s05, this.audioList});

  factory AudioFull.fromJson(Map<String, dynamic> json) {
    return AudioFull(
      s01: json['01'],
      s02: json['02'],
      s03: json['03'],
      s04: json['04'],
      s05: json['05'],
      audioList: json.values.cast<String>().toList(),
    );
  }
}
