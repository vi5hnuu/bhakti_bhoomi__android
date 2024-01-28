import 'package:bhakti_bhoomi/models/mahabharat/MahabharatBookInfoModel.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookInfo extends StatelessWidget {
  final MahabharatBookInfoModel bookInfo;
  const BookInfo({
    super.key,
    required this.bookInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      onTap: () => GoRouter.of(context).pushNamed(Routing.mahabharatBookChaptersInfos, pathParameters: {'bookNo': '${bookInfo.bookNo}'}),
      child: Center(
        child: Text(
          bookInfo.bookNo.toString(),
          textAlign: TextAlign.center,
        ),
      ),
    ));
  }
}
