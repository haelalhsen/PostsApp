import '../../domain/entities/address.dart';
import 'geo_model.dart';

class AddressModel extends Address {
  AddressModel({
    required String? street,
    required String? suite,
    required String? city,
    required String? zipcode,
    required GeoModel? geo, // Accept GeoModel here
  }) : super(
    street: street,
    suite: suite,
    city: city,
    zipcode: zipcode,
    geo: geo, // Pass GeoModel to the Address superclass
  );

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json["street"],
      suite: json["suite"],
      city: json["city"],
      zipcode: json["zipcode"],
      geo: json["geo"] == null ? null : GeoModel.fromJson(json["geo"]), // Parse GeoModel
    );
  }

  Map<String, dynamic> toJson() => {
    "street": street,
    "suite": suite,
    "city": city,
    "zipcode": zipcode,
    "geo": (geo is GeoModel) ? (geo as GeoModel).toJson() : null, // Safely call toJson() on GeoModel
  };
}
