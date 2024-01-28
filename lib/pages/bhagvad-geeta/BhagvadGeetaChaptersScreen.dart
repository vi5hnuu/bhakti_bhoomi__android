import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BhagvadGeetaChaptersScreen extends StatefulWidget {
  final String title;
  const BhagvadGeetaChaptersScreen({super.key, required this.title});

  @override
  State<BhagvadGeetaChaptersScreen> createState() => _BhagvadGeetaChaptersScreenState();
}

class _BhagvadGeetaChaptersScreenState extends State<BhagvadGeetaChaptersScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    BlocProvider.of<BhagvadGeetaBloc>(context).add(FetchBhagvadGeetaChapters(cancelToken: cancelToken));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhagvadGeetaBloc, BhagvadGeetaState>(
      buildWhen: (previous, current) => previous.bhagvadGeetaChapters != current.bhagvadGeetaChapters,
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text('Bhagvad Geeta'),
        ),
        body: state.bhagvadGeetaChapters != null
            ? SingleChildScrollView(
                child: Column(
                  children: state.bhagvadGeetaChapters!
                      .map((e) => InkWell(
                            child: Container(
                              child: Text("${e.chapterNumber} ${e.name}"),
                              height: 60,
                            ),
                            onTap: () => GoRouter.of(context).pushNamed(Routing.bhagvadGeetaChapterShloks, pathParameters: {'chapterNo': '${e.chapterNumber}'}),
                          ))
                      .toList(),
                ),
              )
            : state.error != null
                ? Center(child: Text(state.error!))
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
