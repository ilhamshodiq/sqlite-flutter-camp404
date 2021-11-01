import 'package:flutter/material.dart';
import 'package:prakteksqlite/pages/pelanggan/pelanggan_form.dart';
import 'package:prakteksqlite/pages/pelanggan/pelanggan_list.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Database Pelanggan',
    home: PelangganList(),
  ));
}


