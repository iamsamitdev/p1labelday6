import 'dart:convert';
import 'package:flutter/services.dart';

class CallAPI {

  // สร้าง method read json products
  Future<List> readProduct(barcode) async {
    final resonse = await rootBundle.loadString('assets/data/products.json');
    final data = await json.decode(resonse);
    return data;
  }

}