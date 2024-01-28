import 'package:bhakti_bhoomi/pages/mahabharat/widgets/BookInfo.dart';
import 'package:bhakti_bhoomi/state/mahabharat/mahabharat_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              body: state.allBooksInfo != null
                  ? GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 3 / 5),
                      children: state.allBooksInfo!
                          .map((bookInfo) => BookInfo(
                                bookInfo: bookInfo,
                              ))
                          .toList())
                  : state.error != null
                      ? Center(child: Text(state.error!))
                      : const Center(child: CircularProgressIndicator()),
            ));
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
