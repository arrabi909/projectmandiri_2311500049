import 'package:flutter/material.dart';
import 'dart:ui';
import 'globals.dart';
import 'alumni.dart';
import 'entri_alumni.dart';
import 'cetak_album.dart';

// Ekstensi untuk memformat tanggal ke Bahasa Indonesia
extension on String {
  String toIndonesianDate() {
    var nmBulan = [
      "",
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];

    var komponen = split("-");
    var thn = int.parse(komponen[0]);
    var bln = nmBulan[int.parse(komponen[1])];
    var tgl = int.parse(komponen[2]);
    return "$tgl $bln $thn";
  }
}

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    scrollBehavior: MaterialScrollBehavior().copyWith(
      dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      },
    ),
    home: Home(),
  );
}

class Home extends StatefulWidget {
  @override
  State createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<dynamic> _futureAlumni; // Variabel untuk menampung Future
  final Alumni _alumniService = Alumni(); // Instance Alumni

  Future inisialisasi() async {
    await getIp();
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terhubung ke $ip"))),
    );
  }

  @override
  void initState() {
    super.initState();
    inisialisasi();
    _futureAlumni = _alumniService.tampil(context); // Panggil sekali di awal
  }

  void _refreshData() {
    setState(() {
      _futureAlumni = _alumniService.tampil(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text("E-Book Alumni Universitas XYZ"),
        actions: [
          IconButton(
            onPressed: () async {
              // Logika tambah data alumni
              final pesan = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EntriAlumni()),
              );
              if (context.mounted && pesan != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(pesan),
                    duration: Duration(seconds: 1),
                  ),
                );
                _refreshData(); // Refresh data dengan benar
              }
            },
            tooltip: "Tambah data alumni",
            icon: Icon(Icons.add),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
          ),
          IconButton(
            onPressed: _refreshData, // Panggil fungsi refresh
            tooltip: "Refresh data alumni",
            icon: Icon(Icons.refresh),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
          ),
          IconButton(
            onPressed: () {
              if (daftarAlumni.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Data kosong, tidak bisa mencetak.")),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CetakAlbum()),
              );
            },
            tooltip: "Cetak album alumni",
            icon: Icon(Icons.print),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ), // ButtonStyle
          ), // IconButton
          SizedBox(width: 10.0),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: _futureAlumni, // Gunakan variabel future yang disimpan
          builder: (_, snapshot) => switch (null) {
            _ when snapshot.hasData && snapshot.data.isNotEmpty => InteractiveViewer(
              constrained: false,
              scaleEnabled: false,
              child: DataTable(
                showCheckboxColumn: false,
                dataRowMaxHeight: 60.0,
                headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                columns: [
                  DataColumn(
                    label: Text("Aksi"),
                    headingRowAlignment: MainAxisAlignment.center,
                  ),
                  DataColumn(
                    label: Text("NIM"),
                    headingRowAlignment: MainAxisAlignment.center,
                  ),
                  DataColumn(
                    label: Text("Foto"),
                    headingRowAlignment: MainAxisAlignment.center,
                  ),
                  DataColumn(
                    label: Text("Nama Alumni"),
                    headingRowAlignment: MainAxisAlignment.center,
                  ),
                  DataColumn(
                    label: Text("Program Studi"),
                    headingRowAlignment: MainAxisAlignment.center,
                  ),
                  DataColumn(
                    label: Text("Tempat dan Tanggal Lahir"),
                    headingRowAlignment: MainAxisAlignment.center,
                  ),
                  DataColumn(
                    label: Text("Alamat"),
                    headingRowAlignment: MainAxisAlignment.center,
                  ),
                  DataColumn(
                    label: Text("Nomor HP"),
                    headingRowAlignment: MainAxisAlignment.center,
                  ),
                  DataColumn(
                    label: Text("Tahun Lulus"),
                    headingRowAlignment: MainAxisAlignment.center,
                    numeric: true,
                  ),
                ],
                rows: daftarAlumni.map((alumni) {
                  var bgBaris = switch (alumni.prodi) {
                    "Teknik Informatika" => Color(0xffff7f00),
                    "Sistem Informasi" => Color(0xff0000ff),
                    "Manajemen Informatika" => Color(0xffffff00),
                    "Komputerisasi Akuntansi" => Color(0xff4b3621),
                    "Bisnis Digital" => Color(0xff800000),
                    _ => Color(0xff8f00ff),
                  };

                  // Logika warna teks (Hitam jika prodi Manajemen Informatika, lainnya Putih)
                  var fgSel = (alumni.prodi == "Manajemen Informatika")
                      ? Colors.black
                      : Colors.white;

                  return DataRow(
                    color: WidgetStatePropertyAll(bgBaris),
                    cells: [
                      DataCell(
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  final pesan = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EntriAlumni(
                                        nim: alumni.nim,
                                      ), // EntriAlumni
                                    ), // MaterialPageRoute
                                  );
                                  if (context.mounted && pesan != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(pesan),
                                        duration: Duration(seconds: 1),
                                      ), // SnackBar
                                    );
                                    setState(() => daftarAlumni = daftarAlumni);
                                  }
                                },
                                icon: Icon(Icons.edit),
                                tooltip: "Ubah",
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.orangeAccent,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                      title: Text("Konfirmasi"),
                                      content: Text(
                                        "Apakah Anda yakin akan menghapus data alumni dengan NIM [${alumni.nim}]?",
                                      ),
                                      actions: [
                                        ElevatedButton.icon(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          label: Text("Tidak"),
                                          icon: Icon(Icons.close),
                                          style: ButtonStyle(
                                            backgroundColor:
                                            WidgetStatePropertyAll(
                                              Colors.greenAccent,
                                            ),
                                            foregroundColor:
                                            WidgetStatePropertyAll(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            String pesan = await _alumniService
                                                .hapus(context, alumni.nim);
                                            if (context.mounted) {
                                              Navigator.of(context).pop(pesan);
                                            }
                                          },
                                          label: Text("Ya"),
                                          icon: Icon(Icons.check),
                                          style: ButtonStyle(
                                            backgroundColor:
                                            WidgetStatePropertyAll(
                                              Colors.redAccent,
                                            ),
                                            foregroundColor:
                                            WidgetStatePropertyAll(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ).then((pesan) {
                                    if (pesan != null && context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(pesan.toString()),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                      _refreshData(); // Refresh setelah hapus
                                    }
                                  });
                                },
                                icon: Icon(Icons.delete),
                                tooltip: "Hapus",
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.redAccent,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            alumni.nim,
                            style: TextStyle(color: fgSel),
                          ),
                        ),
                      ),
                      DataCell(
                        Center(
                          child: SizedBox(
                            width: 70.0,
                            height: 60.0,
                            child: Image.network(
                              "$urlGambar${alumni.nim}.jpeg?${DateTime.now().millisecondsSinceEpoch}",
                              width: 70.0,
                              height: 60.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(alumni.nmAlumni, style: TextStyle(color: fgSel)),
                      ),
                      DataCell(
                        Text(alumni.prodi, style: TextStyle(color: fgSel)),
                      ),
                      DataCell(
                        Text(
                          "${alumni.tmptLahir}, ${alumni.tglLahir.toIndonesianDate()}",
                          style: TextStyle(color: fgSel),
                        ),
                      ),
                      DataCell(
                        Text(alumni.alamat, style: TextStyle(color: fgSel)),
                      ),
                      DataCell(
                        Text(alumni.noHp, style: TextStyle(color: fgSel)),
                      ),
                      DataCell(
                        Center(
                          child: Text(
                            "${alumni.thnLulus}",
                            style: TextStyle(color: fgSel),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            _ when snapshot.hasError => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.warning, color: Colors.yellow, size: 200.0),
                Text(
                  "Tidak dapat memuat data:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            _ when snapshot.connectionState == ConnectionState.waiting =>
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text("Memuat...", textAlign: TextAlign.center),
                  ],
                ),
            _ => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel, color: Colors.red, size: 200.0),
                Text(
                  "Tidak ada data",
                  style: TextStyle(fontSize: 32.0, color: Colors.grey),
                ),
              ],
            ),
          },
        ),
      ),
    );
  }
}
