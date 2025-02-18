import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class BhagvadGeetaChaptersScreen extends StatefulWidget {
  final String title;

  const BhagvadGeetaChaptersScreen({super.key, required this.title});

  @override
  State<BhagvadGeetaChaptersScreen> createState() =>
      _BhagvadGeetaChaptersScreenState();
}

class _BhagvadGeetaChaptersScreenState
    extends State<BhagvadGeetaChaptersScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    initBhagvadGeetaChapters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhagvadGeetaBloc, BhagvadGeetaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Bhagvad Geeta',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Kalam",
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: state.bhagvadGeetaChapters != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: state.bhagvadGeetaChapters!
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: RoundedListTile(
                                itemNo: e.chapterNumber,
                                text: "${e.chapterNumber} ${e.name}",
                                onTap: () => GoRouter.of(context).pushNamed(
                                    Routing.bhagvadGeetaChapterShloks,
                                    pathParameters: {
                                      'chapterNo': '${e.chapterNumber}'
                                    }),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              )
            : state.isError(forr: Httpstates.BHAGVAD_GEETA_CHAPTERS)
                ? Center(
                    child: RetryAgain(
                        onRetry: initBhagvadGeetaChapters,
                        error: state.getError(
                            forr: Httpstates.BHAGVAD_GEETA_CHAPTERS)!))
                : Center(
                    child: SpinKitThreeBounce(
                        color: Theme.of(context).primaryColor)),
      ),
    );
  }

  initBhagvadGeetaChapters() {
    BlocProvider.of<BhagvadGeetaBloc>(context)
        .add(FetchBhagvadGeetaChapters(cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
