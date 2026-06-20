import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/chanakyaNeeti/chanakya_neeti_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChanakyaNeetiChaptersScreen extends StatefulWidget {
  final String title;
  const ChanakyaNeetiChaptersScreen({super.key, required this.title});

  @override
  State<ChanakyaNeetiChaptersScreen> createState() => _ChanakyaNeetiChaptersScreenState();
}

class _ChanakyaNeetiChaptersScreenState extends State<ChanakyaNeetiChaptersScreen> {
  final CancelToken token = CancelToken();

  @override
  void initState() {
    initChanakyaNeetiChaptersInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChanakyaNeetiBloc, ChanakyaNeetiState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final chaptersInfo = state.allChaptersInfo;
        return AppScaffold(
          title: 'Chanakya Neeti',
          subtitle: 'चाणक्य नीति',
          body: chaptersInfo != null
              ? RefreshIndicator(
                  onRefresh: () async => initChanakyaNeetiChaptersInfo(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: chaptersInfo.length,
                    itemBuilder: (context, index) {
                      final chapterInfo = chaptersInfo[index];
                      return IndexTile(
                        number: '${chapterInfo.chapterNo}',
                        title: 'Chapter ${chapterInfo.chapterNo}',
                        meta: '${chapterInfo.versesCount} verses',
                        onTap: () => GoRouter.of(context).pushNamed(
                          Routing.chanakyaNitiChapterShlok.name,
                          pathParameters: {'chapterNo': '${chapterInfo.chapterNo}'},
                        ),
                      );
                    },
                  ),
                )
              : state.isError(forr: Httpstates.CHANAKYA_NEETI_CHAPTERS_INFO)
                  ? RetryAgain(onRetry: initChanakyaNeetiChaptersInfo, error: state.getError(forr: Httpstates.CHANAKYA_NEETI_CHAPTERS_INFO)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initChanakyaNeetiChaptersInfo() {
    BlocProvider.of<ChanakyaNeetiBloc>(context).add(FetchChanakyaNeetiChaptersInfo(cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
