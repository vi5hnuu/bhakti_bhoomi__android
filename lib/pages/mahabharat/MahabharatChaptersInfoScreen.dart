import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
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
          title: Text('Mahabharat | Book No - ${bookNo}', style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 24, fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<MahabharatBloc, MahabharatState>(
          builder: (context, state) => ListView.builder(
            itemCount: state.getBooksInfo(bookNo: bookNo)!.info.length,
            itemBuilder: (context, index) => Card(
                child: RoundedListTile(
              itemNo: index + 1,
              text: 'Chapter ${index + 1} | total verses ${state.getBooksInfo(bookNo: bookNo)!.info['${index + 1}']!}',
              onTap: () => GoRouter.of(context).pushNamed(Routing.mahabharatBookChapterShloks, pathParameters: {'bookNo': '${bookNo}', 'chapterNo': '${index + 1}'}),
            )),
          ),
        ));
  }
}
