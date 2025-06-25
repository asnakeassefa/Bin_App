import 'package:equatable/equatable.dart';

// class UserDataModel extends User with EquatableMixin {
//   const UserDataModel({
//     required super.country,
//     required super.password,
//     required super.fullName,
//     required super.email,
//     required super.role,
//     required super.phoneNumber,
//     required super.confirmPassword,
//   });

//   factory UserDataModel.fromJson(Map<String, dynamic> json) {
//     return UserDataModel(
//       fullName: json['fullName'],
//       email: json['email'],
//       role: json['role'],
//       confirmPassword: json['confirmPassword'],
//       country: json['country'],
//       password: json['password'],
//       phoneNumber: json['phoneNumber'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'fullName': fullName,
//       'email': email,
//       'role': role,
//       'country': country,
//       'password': password,
//       'phoneNumber': phoneNumber,
//       'confirmPassword': confirmPassword,
//     };
//   }

//   @override
//   List<Object?> get props => [
//         fullName,
//         email,
//         role,
//         country,
//         password,
//         phoneNumber,
//         confirmPassword,
//       ];
// }
