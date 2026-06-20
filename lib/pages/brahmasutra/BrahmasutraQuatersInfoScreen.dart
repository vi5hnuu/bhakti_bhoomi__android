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

class BrahmasutraQuatersInfoScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  const BrahmasutraQuatersInfoScreen({super.key, required this.title, required this.chapterNo});

  @override
  State<BrahmasutraQuatersInfoScreen> createState() => _BrahmasutraQuatersInfoScreenState();
}

class _BrahmasutraQuatersInfoScreenState extends State<BrahmasutraQuatersInfoScreen> {
  CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    _reload();
    super.initState();
  }

  void _reload() {
    cancelToken.cancel("reload");
    cancelToken = CancelToken();
    BlocProvider.of<BrahmaSutraBloc>(context).add(FetchBrahmasutraInfo(cancelToken: cancelToken));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrahmaSutraBloc, BrahmaSutraState>(
      builder: (context, state) {
        final info = state.brahmasutraInfo;
        // Guard the per-chapter lookup so a missing chapter never throws.
        final totalQuaters = info?.chaptersInfo['${widget.chapterNo}']?.totalQuaters ?? 0;
        return AppScaffold(
          title: 'Brahma Sutra · Ch ${widget.chapterNo}',
          subtitle: 'ब्रह्मसूत्र · पाद',
          body: info != null
              ? RefreshIndicator(
                  onRefresh: () async => _reload(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: totalQuaters,
                    itemBuilder: (context, index) => IndexTile(
                      number: '${index + 1}',
                      title: 'Pada ${index + 1}',
                      subtitle: 'पाद ${index + 1}',
                      onTap: () => GoRouter.of(context).pushNamed(
                        Routing.brahmasutra.name,
                        pathParameters: {'chapterNo': '${widget.chapterNo}', 'quaterNo': '${index + 1}'},
                      ),
                    ),
                  ),
                )
              : state.isError(forr: Httpstates.BRAHMA_SUTRA_INFO)
                  ? RetryAgain(onRetry: _reload, error: state.getError(forr: Httpstates.BRAHMA_SUTRA_INFO)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
