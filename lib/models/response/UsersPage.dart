import 'package:bhakti_bhoomi/models/UserInfo.dart';

class UsersPage {
  //accessed by admin only
  final List<UserInfo> users;
  final int totalPages;
  final int pageNo;
  final bool firstPage;
  final bool lastPage;

  const UsersPage({required this.users, required this.totalPages, required this.pageNo, required this.firstPage, required this.lastPage});

  factory UsersPage.fromJson(Map<String, dynamic> data) {
    return UsersPage(
      users: (data['users'] as List).map((e) => UserInfo.fromJson(e)).toList(growable: false),
      totalPages: data['totalPages'],
      pageNo: data['pageNo'],
      firstPage: data['firstPage'],
      lastPage: data['lastPage'],
    );
  }
}
