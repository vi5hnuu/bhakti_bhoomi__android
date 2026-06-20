import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/yogaSutra/yoga_sutra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class YogaSutraChaptersScreen extends StatefulWidget {
  final String title;
  const YogaSutraChaptersScreen({super.key, required this.title});

  @override
  State<YogaSutraChaptersScreen> createState() => _YogaSutraChaptersScreenState();
}

class _YogaSutraChaptersScreenState extends State<YogaSutraChaptersScreen> {
  final CancelToken token = CancelToken();

  @override
  void initState() {
    initYogaSutraInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YogaSutraBloc, YogaSutraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final info = state.yogaSutraInfo;
        return AppScaffold(
          title: 'Yoga Sutra',
          subtitle: 'योगसूत्र',
          body: info != null
              ? RefreshIndicator(
                  onRefresh: () async => initYogaSutraInfo(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: info.totalSutra.length,
                    itemBuilder: (context, index) => IndexTile(
                      number: '${index + 1}',
                      title: 'Chapter ${index + 1}',
                      subtitle: 'पाद ${index + 1}',
                      onTap: () => GoRouter.of(context).pushNamed(Routing.yogaSutra.name, pathParameters: {'chapterNo': '${index + 1}'}),
                    ),
                  ),
                )
              : state.isError(forr: Httpstates.YOGASUTRA_INFO)
                  ? RetryAgain(onRetry: initYogaSutraInfo, error: state.getError(forr: Httpstates.YOGASUTRA_INFO)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initYogaSutraInfo() {
    BlocProvider.of<YogaSutraBloc>(context).add(FetchYogasutraInfo(cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
