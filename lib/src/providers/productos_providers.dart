
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:form_validation/src/models/producto_model.dart';

class ProductosProviders{
  final String url = "https://flutterlogin-5fe6c.firebaseio.com";

  Future<bool> crearProducto(ProductoModel model) async{
    final _url = "$url/productos.json";
    final resp = await http.post(_url, body: productoModelToJson(model));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<bool> actualizarProducto(ProductoModel model) async{
    final _url = "$url/productos/${model.id}.json";
    final resp = await http.put(_url, body: productoModelToJson(model));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductoModel>> getProductos() async{
    final prod = List<ProductoModel>();
    final _url = "$url/productos.json";
    final resp = await http.get(_url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    if(decodedData == null){
      return [];
    }
    decodedData.forEach((key, value) {
      final tmp = ProductoModel.fromJson(value);
      tmp.id = key;
      prod.add(tmp);
    });
    return prod;
  }

  Future<int> deleteProducto(String id) async{
    final _url = "$url/productos/$id.json";
    final resp = await http.delete(_url);
    print(resp.body);
    return 1;
  }
}