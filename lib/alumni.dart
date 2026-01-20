import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart';
import 'globals.dart';
import 'package:flutter/material.dart';

var daftarAlumni = <Alumni>[];
var daftarFoto = <Uint8List>[];

class Alumni {
  String nim;
  String nmAlumni;
  String prodi;
  String tmptLahir;
  String tglLahir;
  String alamat;
  String noHp;
  int thnLulus;
  String foto;

  Alumni({
    this.nim = '',
    this.nmAlumni = '',
    this.prodi = '',
    this.tmptLahir = '',
    this.tglLahir = '',
    this.alamat = '',
    this.noHp = '',
    this.thnLulus = 0,
    this.foto = '',
  });

  factory Alumni.fromJson(Map json) => Alumni(
    nim: json['nim'] ?? '',
    nmAlumni: json['nm_alumni'] ?? '',
    prodi: json['prodi'] ?? '',
    tmptLahir: json['tmpt_lahir'] ?? '',
    tglLahir: json['tgl_lahir'] ?? '',
    alamat: json['alamat'] ?? '',
    noHp: json['no_hp'] ?? '',
    thnLulus: json['thn_lulus'] == null || json['thn_lulus'] == ''
        ? 0
        : int.parse(json['thn_lulus']),
    foto: json['foto'] ?? '',
  );

  Future ambilByteFoto(BuildContext context, String nim) async {
    final response =
    await get(Uri.parse("$urlGambar$nim.jpeg"));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Gagal memuat foto alumni [$nim]:\n${response.body}"),
        ), // SnackBar
      );
    }
  }

  Future tampil(BuildContext context) async {
    await getIp().then((value) => ip = value);

    final response = await post(
      Uri.parse(urlApi),
      body: {'aksi': 'tampil'},
    );

    daftarAlumni.clear();
    daftarFoto.clear();

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      for (var item in data) {
        var alumni = Alumni.fromJson(item);
        daftarAlumni.add(alumni);
        daftarFoto.add(await ambilByteFoto(context, alumni.nim));
      }
      return daftarAlumni;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text("Gagal memuat data alumni:\n${response.body}"),
        ), // SnackBar
      );
    }
  }

  Future simpan(BuildContext context) async {
    await getIp().then((value) => ip = value);

    final response = await post(
      Uri.parse(urlApi),
      body: {
        "aksi": "simpan",
        "nim": nim,
        "nm_alumni": nmAlumni,
        "prodi": prodi,
        "tmpt_lahir": tmptLahir,
        "tgl_lahir": tglLahir,
        "alamat": alamat,
        "no_hp": noHp,
        "thn_lulus": "$thnLulus",
        "foto": foto,
      },
    );

    if (response.statusCode == 200) {
      return "Data alumni ${response.body} disimpan";
    } else {
      return "Data alumni gagal disimpan: ${response.body}";
    }
  }

  Future ubah(BuildContext context, String varNim) async {
    final response = await post(
      Uri.parse(urlApi),
      body: {
        "aksi": "ubah",
        "nim": varNim,
        "nm_alumni": nmAlumni,
        "prodi": prodi,
        "tmpt_lahir": tmptLahir,
        "tgl_lahir": tglLahir,
        "alamat": alamat,
        "no_hp": noHp,
        "thn_lulus": "$thnLulus",
        "foto": foto,
      },
    );

    if (response.statusCode == 200) {
      return "Data alumni [$varNim] ${response.body} diubah";
    } else {
      return "Data alumni [$varNim] gagal diubah: ${response.body}";
    }
  }

  Future hapus(BuildContext context, String varNim) async {
    final response = await post(
      Uri.parse(urlApi),
      body: {
        "aksi": "hapus",
        "nim": varNim,
      },
    );

    if (response.statusCode == 200) {
      return "Data alumni [$varNim] ${response.body} dihapus";
    } else {
      return "Data alumni [$varNim] gagal dihapus: ${response.body}";
    }
  }

}
