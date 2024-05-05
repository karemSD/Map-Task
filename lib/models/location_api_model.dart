  import 'dart:convert';
List<LocationApiModel> locationApiModelFromJson(String str) => List<LocationApiModel>.from(json.decode(str).map((x) => LocationApiModel.fromJson(x)));

String locationApiModelToJson(List<LocationApiModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationApiModel {
  LocationApiModel({
    required this.id,
    required this.name,
    required this.longLat,
  });

  int id;
  String name;
  String longLat;

  factory LocationApiModel.fromJson(Map<String, dynamic> json) => LocationApiModel(
    id: json["id"],
    name: json["name"],
    longLat: json["longLat"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "longLat": longLat,
  };
}

