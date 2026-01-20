import 'package:flutter/services.dart';

Future getIp() async => await rootBundle.loadString("assets/ip.txt");
late String ip;

final urlApi = "http://$ip/latihan_crud/alumni.php";
final urlGambar = "http://$ip/latihan_crud/foto/";
