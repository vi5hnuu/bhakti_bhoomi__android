import 'package:bhakti_bhoomi/models/UserImageMeta.dart';
import 'package:bhakti_bhoomi/models/UserRole.dart';

class UserInfo {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final List<UserRole> role;
  final DateTime createdAt;
  final updatedAt;
  final UserImageMeta? profileMeta;
  final UserImageMeta? posterMeta;
  final bool enabled;
  final bool locked;

  const UserInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    this.profileMeta,
    this.posterMeta,
    this.enabled = true,
    this.locked = false,
  });

  factory UserInfo.test() => UserInfo(
        id: 'test',
        firstName: 'test',
        lastName: 'test',
        email: 'xyz@gmail.com',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        role: [UserRole.roleAdmin],
      );

  factory UserInfo.fromJson(Map<String, dynamic> userInfo) {
    return UserInfo(
      id: userInfo['id'],
      firstName: userInfo['firstName'],
      lastName: userInfo['lastName'],
      email: userInfo['email'],
      role: (userInfo['role'] as List).map((e) => UserRole.fromJson(e)).toList(growable: false),
      createdAt: DateTime.parse(userInfo['createdAt']),
      updatedAt: DateTime.parse(userInfo['updatedAt']),
      profileMeta: userInfo['profileMeta'] != null ? UserImageMeta.fromJson(userInfo['profileMeta']) : null,
      posterMeta: userInfo['posterMeta'] != null ? UserImageMeta.fromJson(userInfo['posterMeta']) : null,
      enabled: userInfo['enabled'],
      locked: userInfo['locked'],
    );
  }
}
