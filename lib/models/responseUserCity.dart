// To parse this JSON data, do
//
//     final responseUserCity = responseUserCityFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ResponseUserCity responseUserCityFromJson(String str) =>
    ResponseUserCity.fromJson(json.decode(str));

String responseUserCityToJson(ResponseUserCity data) =>
    json.encode(data.toJson());

class ResponseUserCity {
  ResponseUserCity({
    required this.status,
    required this.message,
    required this.cities,
  });

  final String status;
  final String message;
  final List<City> cities;

  factory ResponseUserCity.fromJson(Map<String, dynamic> json) =>
      ResponseUserCity(
        status: json["status"],
        message: json["message"],
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "cities": List<dynamic>.from(cities.map((x) => x.toJson())),
      };
}

class City {
  City({
    required this.id,
    required this.provinceId,
    required this.name,
    //required this.createdAt,
    //required this.updatedAt,
    //required this.deletedAt,
  });

  final int id;
  final int provinceId;
  final String name;
  //final DateTime createdAt;
  //final DateTime updatedAt;
  //final dynamic deletedAt;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        provinceId: json["province_id"],
        name: json["name"],
        //createdAt: DateTime.parse(json["created_at"]),
        //updatedAt: DateTime.parse(json["updated_at"]),
        //deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "province_id": provinceId,
        "name": name,
        //"created_at": createdAt.toIso8601String(),
        //"updated_at": updatedAt.toIso8601String(),
        //"deleted_at": deletedAt,
      };
}
