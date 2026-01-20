import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'dart:convert';
import 'globals.dart';
import 'alumni.dart';

late String nimEdit;

class EntriAlumni extends StatefulWidget {
  final String? nim;

  EntriAlumni({super.key, this.nim}) {
    nimEdit = nim ?? "";
  }

  @override
  State createState() => EntriAlumniState();
}

class EntriAlumniState extends State<EntriAlumni> {
  final ImagePicker picker = ImagePicker();
  Uint8List? gambarFoto;

  var alumniEdit = daftarAlumni.firstWhere(
        (alumni) => alumni.nim == nimEdit,
    orElse: () => Alumni(),
  );

  final modeEdit = nimEdit.isNotEmpty;
  late var nim = !modeEdit ? "" : alumniEdit.nim;
  late var nmAlumni = !modeEdit ? "" : alumniEdit.nmAlumni;
  late var prodi =
  !modeEdit ? "Program Studi" : alumniEdit.prodi;
  late var tmptLahir =
  !modeEdit ? "" : alumniEdit.tmptLahir;
  late var tglLahir =
  !modeEdit ? "" : alumniEdit.tglLahir;
  late var alamat = !modeEdit ? "" : alumniEdit.alamat;
  late var noHp = !modeEdit ? "" : alumniEdit.noHp;
  late var thnLulus =
  !modeEdit ? 0 : alumniEdit.thnLulus;
  late var strFoto = !modeEdit ? "" : alumniEdit.foto;

  late var ctrlTglLahir =
  TextEditingController(text: tglLahir);
  late var ctrlThnLulus = TextEditingController(
    text: !modeEdit ? "" : "$thnLulus",
  );

  var fnTglLahir = FocusNode();
  var fnAlamat = FocusNode();

  @override
  void initState() {
    super.initState();
    fnTglLahir.addListener(() {
      if (fnTglLahir.hasFocus) {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        ).then((value) {
          if (value != null) {
            var tgl =
            "${value.day}".padLeft(2, '0');
            var bln =
            "${value.month}".padLeft(2, '0');
            var thn = value.year;
            ctrlTglLahir.text = "$thn-$bln-$tgl";
          } else {
            ctrlTglLahir.text = ctrlTglLahir.text;
          }
          setState(() => tglLahir = ctrlTglLahir.text);
          fnAlamat.requestFocus();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: "Kembali",
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
            "${!modeEdit ? 'Entri' : 'Edit'} Data Alumni"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              initialValue: nim,
              readOnly: modeEdit,
              maxLength: 10,
              decoration:
              InputDecoration(labelText: "NIM"),
              onChanged: (text) =>
                  setState(() => nim = text),
            ),
            TextFormField(
              initialValue: nmAlumni,
              maxLength: 30,
              decoration: InputDecoration(
                  labelText: "Nama Alumni"),
              onChanged: (text) =>
                  setState(() => nmAlumni = text),
            ),
            DropdownButton(
              isExpanded: true,
              value: prodi,
              items: [
                "Program Studi",
                "Sistem Informasi",
                "Teknik Informatika",
                "Bisnis Digital",
                "Manajemen Informatika",
                "Komputerisasi Akuntansi",
                "Sistem Informasi Manajemen",
              ]
                  .map(
                    (x) => DropdownMenuItem(
                  enabled: x != "Program Studi",
                  value: x,
                  child: Text(x),
                ),
              )
                  .toList(),
              onChanged: (value) =>
                  setState(() => prodi = value!),
            ),
            TextFormField(
              initialValue: tmptLahir,
              maxLength: 20,
              decoration: InputDecoration(
                  labelText: "Tempat Lahir"),
              onChanged: (text) =>
                  setState(() => tmptLahir = text),
            ),
            TextFormField(
              controller: ctrlTglLahir,
              focusNode: fnTglLahir,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: "Tanggal Lahir"),
            ),
            TextFormField(
              focusNode: fnAlamat,
              initialValue: alamat,
              minLines: 1,
              maxLines: 999,
              decoration:
              InputDecoration(labelText: "Alamat"),
              onChanged: (text) =>
                  setState(() => alamat = text),
            ),
            TextFormField(
              initialValue: noHp,
              maxLength: 13,
              keyboardType: TextInputType.number,
              decoration:
              InputDecoration(labelText: "Nomor HP"),
              onChanged: (text) =>
                  setState(() => noHp = text),
            ),
            TextFormField(
              controller: ctrlThnLulus,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Tahun Lulus"),
              onChanged: (text) =>
                  setState(() => thnLulus = int.parse(text)),
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                  WidgetStateProperty.all(
                      Colors.purple),
                  foregroundColor:
                  WidgetStateProperty.all(
                      Colors.white),
                ),
                onPressed: () async {
                  if (!kIsWeb) {
                    final XFile? image =
                    await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      var imgFile = File(image.path);
                      var imgBytes =
                      await imgFile.readAsBytes();
                      setState(() {
                        gambarFoto = imgBytes;
                        strFoto =
                            base64Encode(imgBytes);
                      });
                    }
                  } else {
                    final image = await FilePicker
                        .platform
                        .pickFiles(
                      type: FileType.image,
                    );
                    if (image != null) {
                      var imgFile = image.files.first;
                      var imgBytes = imgFile.bytes!;
                      setState(() {
                        gambarFoto = imgBytes;
                        strFoto =
                            base64Encode(imgBytes);
                      });
                    }
                  }
                },
                child: Text("Cari Foto..."),
              ),
            ),
            SizedBox(height: 10.0),
            switch (null) {
              _ when gambarFoto != null =>
                  Image.memory(
                    gambarFoto!,
                    width: 210.0,
                    height: 180.0,
                  ),
              _ when modeEdit =>
                  Image.network(
                    "$urlGambar$nimEdit.jpeg?${DateTime.now().millisecondsSinceEpoch}",
                    width: 210.0,
                    height: 180.0,
                  ),
              _ =>
                  SizedBox(
                    width: 210.0,
                    height: 180.0,
                    child: Placeholder(
                      child: Center(
                        child: Text("Tidak ada foto"),
                      ),
                    ),
                  ),
            },
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                if(modeEdit && strFoto.isEmpty) {
                  strFoto = base64Encode(
                    await alumniEdit.ambilByteFoto(context, nim),
                  );
                }
                if (nim.isNotEmpty &&
                    nmAlumni.isNotEmpty &&
                    prodi != "Program Studi" &&
                    tmptLahir.isNotEmpty &&
                    tglLahir.isNotEmpty &&
                    alamat.isNotEmpty &&
                    noHp.isNotEmpty &&
                    ctrlThnLulus.text.isNotEmpty &&
                    strFoto.isNotEmpty) {
                  var alumni = Alumni(
                    nim: nim,
                    nmAlumni: nmAlumni,
                    prodi: prodi,
                    tmptLahir: tmptLahir,
                    tglLahir: tglLahir,
                    alamat: alamat,
                    noHp: noHp,
                    thnLulus: thnLulus,
                    foto: strFoto,
                  );
                  Navigator.of(context).pop(
                    !modeEdit
                        ?alumni.simpan(context)
                        :alumni.ubah(context, nimEdit),
                  );
                  if (!modeEdit)
                  setState(() {
                    nim = "";
                    nmAlumni = "";
                    prodi = "Program Studi";
                    tmptLahir = "";
                    tglLahir = "";
                    alamat = "";
                    noHp = "";
                    thnLulus = 0;
                    gambarFoto = null;
                    strFoto = "";
                  });
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                          "Data alumni belum lengkap"),
                      duration:
                      Duration(seconds: 1),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor:
                WidgetStatePropertyAll(
                    Colors.purple),
                foregroundColor:
                WidgetStatePropertyAll(
                    Colors.white),
              ),
              child: Text(
                  !modeEdit ? "Simpan" : "Ubah"),
            ),
          ],
        ),
      ),
    );
  }
}
