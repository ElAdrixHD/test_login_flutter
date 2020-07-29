import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
  ProductoModel({
    this.id,
    this.title = "",
    this.value = 0.0,
    this.disponible = false,
    this.url,
  });

  String id;
  String title;
  double value;
  bool disponible;
  String url;

  factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
    id        : json["id"],
    title     : json["title"],
    value     : json["value"],
    disponible: json["disponible"],
    url       : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "title"     : title,
    "value"     : value,
    "disponible": disponible,
    "url"       : url,
  };

  @override
  String toString() {
    return 'ProductoModel{id: $id, title: $title, value: $value, disponible: $disponible, url: $url}';
  }
}