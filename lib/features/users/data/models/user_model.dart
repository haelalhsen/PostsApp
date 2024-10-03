import '../../domain/entities/user.dart';
import 'address_model.dart';
import 'company_model.dart';

class UserModel extends User {
  UserModel({
    required int? id,
    required String? name,
    required String? username,
    required String? email,
    required AddressModel? address, // Accept AddressModel
    required String? phone,
    required String? website,
    required CompanyModel? company, // Accept CompanyModel
  }) : super(
          id: id,
          name: name,
          username: username,
          email: email,
          address: address,
          // Now directly pass AddressModel
          phone: phone,
          website: website,
          company: company, // Now directly pass CompanyModel
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      username: json["username"],
      email: json["email"],
      address: json["address"] == null
          ? null
          : AddressModel.fromJson(json["address"]),
      phone: json["phone"],
      website: json["website"],
      company: json["company"] == null
          ? null
          : CompanyModel.fromJson(json["company"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "address": (address is AddressModel)
            ? (address as AddressModel).toJson()
            : null,
        "phone": phone,
        "website": website,
        "company": (company is CompanyModel)
            ? (company as CompanyModel).toJson()
            : null,
      };
}
