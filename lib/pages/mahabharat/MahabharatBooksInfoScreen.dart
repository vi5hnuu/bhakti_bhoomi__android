import 'package:bhakti_bhoomi/models/mahabharat/MahabharatBookInfoModel.dart';
import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MahabharatBookInfoScreen extends StatefulWidget {
  final String title;
  MahabharatBookInfoScreen({super.key, required this.title});

  @override
  State<MahabharatBookInfoScreen> createState() => _MahabharatBookInfoScreenState();
}

class _MahabharatBookInfoScreenState extends State<MahabharatBookInfoScreen> {
  final CancelToken token = CancelToken();

  @override
  void initState() {
    BlocProvider.of<MahabharatBloc>(context).add(FetchMahabharatInfoEvent(cancelToken: token));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MahabharatBloc, MahabharatState>(
      buildWhen: (previous, current) => previous.allBooksInfo != current.allBooksInfo,
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Mahabharat'),
          ),
          body: (state.isLoading || state.allBooksInfo == null) && state.error == null
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

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
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
