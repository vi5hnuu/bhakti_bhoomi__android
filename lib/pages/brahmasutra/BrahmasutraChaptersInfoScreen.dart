import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/brahmaSutra/brahma_sutra_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BrahmasutraChaptersInfoScreen extends StatefulWidget {
  final String title;
  const BrahmasutraChaptersInfoScreen({super.key, required this.title});

  @override
  State<BrahmasutraChaptersInfoScreen> createState() => _BrahmasutraChaptersInfoScreenState();
}

class _BrahmasutraChaptersInfoScreenState extends State<BrahmasutraChaptersInfoScreen> {
  CancelToken? cancelToken = CancelToken();

  @override
  void initState() {
    initBrahmaSutraInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrahmaSutraBloc, BrahmaSutraState>(
      builder: (context, state) {
        final info = state.brahmasutraInfo;
        return AppScaffold(
          title: 'Brahma Sutra',
          subtitle: 'ब्रह्मसूत्र',
          body: info != null
              ? RefreshIndicator(
                  onRefresh: () async => initBrahmaSutraInfo(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: info.totalChapters,
                    itemBuilder: (context, index) => IndexTile(
                      number: '${index + 1}',
                      title: 'Chapter ${index + 1}',
                      subtitle: 'अध्याय ${index + 1}',
                      onTap: () => GoRouter.of(context).pushNamed(Routing.brahmasutraQuatersInfo.name, pathParameters: {'chapterNo': '${index + 1}'}),
                    ),
                  ),
                )
              : state.isError(forr: Httpstates.BRAHMA_SUTRA_INFO)
                  ? RetryAgain(onRetry: initBrahmaSutraInfo, error: state.getError(forr: Httpstates.BRAHMA_SUTRA_INFO)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initBrahmaSutraInfo() {
    BlocProvider.of<BrahmaSutraBloc>(context).add(FetchBrahmasutraInfo(cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken!.cancel("Cancelled");
    super.dispose();
  }
}
