import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
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
    initBhagvadGeetaChapters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhagvadGeetaBloc, BhagvadGeetaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final chapters = state.bhagvadGeetaChapters;
        return AppScaffold(
          title: 'Bhagavad Gita',
          subtitle: 'श्रीमद्भगवद्गीता · 18 अध्याय',
          body: chapters != null
              ? RefreshIndicator(
                  onRefresh: () async => initBhagvadGeetaChapters(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: chapters.length,
                    itemBuilder: (context, i) {
                      final e = chapters[i];
                      return IndexTile(
                        number: '${e.chapterNumber}',
                        title: e.name,
                        subtitle: e.translation,
                        meta: '${e.versesCount} verses',
                        onTap: () => GoRouter.of(context).pushNamed(
                          Routing.bhagvadGeetaChapterShloks.name,
                          pathParameters: {'chapterNo': '${e.chapterNumber}'},
                        ),
                      );
                    },
                  ),
                )
              : state.isError(forr: Httpstates.BHAGVAD_GEETA_CHAPTERS)
                  ? RetryAgain(onRetry: initBhagvadGeetaChapters, error: state.getError(forr: Httpstates.BHAGVAD_GEETA_CHAPTERS)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initBhagvadGeetaChapters() {
    BlocProvider.of<BhagvadGeetaBloc>(context).add(FetchBhagvadGeetaChapters(cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
