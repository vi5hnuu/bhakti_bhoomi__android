import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MahabharatChaptersInfoScreen extends StatelessWidget {
  final String title;
  final int bookNo;
  const MahabharatChaptersInfoScreen({super.key, required this.title, required this.bookNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mahabharat'),
        ),
        body: BlocBuilder<MahabharatBloc, MahabharatState>(
          builder: (context, state) => ListView.builder(
            itemCount: state.getBooksInfo(bookNo: bookNo)!.info.length,
            itemBuilder: (context, index) => Card(
              child: InkWell(
                  onTap: () => GoRouter.of(context).pushNamed(Routing.mahabharatBookChapterShloks, pathParameters: {'bookNo': '${bookNo}', 'chapterNo': '${index + 1}'}),
                  child: ListTile(
                    title: Text(
                      'Chapter ${index + 1} totalVerses ${state.getBooksInfo(bookNo: bookNo)!.info['${index + 1}']!}',
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),
          ),
        ));
  }
}
