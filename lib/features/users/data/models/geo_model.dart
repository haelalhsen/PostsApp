import '../../domain/entities/geo.dart';

class GeoModel extends Geo {
  GeoModel({
    required String? lat,
    required String? lng,
  }) : super(lat: lat, lng: lng);

  factory GeoModel.fromJson(Map<String, dynamic> json) {
    return GeoModel(
      lat: json["lat"],
      lng: json["lng"],
    );
  }

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}
