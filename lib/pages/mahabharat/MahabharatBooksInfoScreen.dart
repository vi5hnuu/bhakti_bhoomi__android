import 'package:bhakti_bhoomi/models/mahabharat/MahabharatBookInfoModel.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MahabharatBookInfoScreen extends StatelessWidget {
  final String title;
  const MahabharatBookInfoScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatInfoEvent()));

    return BlocBuilder<MahabharatBloc, MahabharatState>(
      buildWhen: (previous, current) => previous.allBooksInfo != current.allBooksInfo,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Mahabharat'),
          ),
          body: (state.isLoading) && state.error == null
              ? const CircularProgressIndicator()
              : state.error != null
                  ? Text(state.error!)
                  : GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 3 / 5),
                      children: state.allBooksInfo!
                          .map((bookInfo) => BookInfo(
                                bookInfo: bookInfo,
                              ))
                          .toList())),
    );
  }
}

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
