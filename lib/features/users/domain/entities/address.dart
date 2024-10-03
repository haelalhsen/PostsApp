import 'package:equatable/equatable.dart';

import 'geo.dart';

class Address extends Equatable {
  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  final String? street;
  final String? suite;
  final String? city;
  final String? zipcode;
  final Geo? geo;

  @override
  List<Object?> get props => [
    street, suite, city, zipcode, geo, ];
}