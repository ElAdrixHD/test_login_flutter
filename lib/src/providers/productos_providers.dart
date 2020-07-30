
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:form_validation/src/models/producto_model.dart';
import 'package:mime_type/mime_type.dart';

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

  Future<String> subirImagen(File img)async{
    //lr33el4r
    final _url = Uri.parse("https://api.cloudinary.com/v1_1/dwmcycvlr/image/upload?upload_preset=lr33el4r");
    final mimeType = mime(img.path).split("/");

    final req = http.MultipartRequest("POST",_url);
    final file = await http.MultipartFile.fromPath("file", img.path, contentType: MediaType(mimeType[0], mimeType[1]));
    req.files.add(file);

    final streamResp = await req.send();
    final resp = await http.Response.fromStream(streamResp);
    if(resp.statusCode != 200 &&resp.statusCode != 201){
      print("Salio mal subida imagen");
      print(resp.body);
      return null;
    }

    final data = json.decode(resp.body);
    print(data);
    return data["secure_url"];

  }
}