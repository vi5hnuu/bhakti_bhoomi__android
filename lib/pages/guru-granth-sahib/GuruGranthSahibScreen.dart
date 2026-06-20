import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/guruGranthSahib/guru_granth_sahib_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GuruGranthSahibInfoScreen extends StatefulWidget {
  final String title;
  const GuruGranthSahibInfoScreen({super.key, required this.title});

  @override
  State<GuruGranthSahibInfoScreen> createState() => _GuruGranthSahibInfoScreenState();
}

class _GuruGranthSahibInfoScreenState extends State<GuruGranthSahibInfoScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    initGuruGranthSahibInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuruGranthSahibBloc, GuruGranthSahibState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final info = state.getInfo();
        return AppScaffold(
          title: 'Guru Granth Sahib',
          subtitle: 'ਗੁਰੂ ਗ੍ਰੰਥ ਸਾਹਿਬ · ਰਾਗ',
          body: info != null
              ? RefreshIndicator(
                  onRefresh: () async => initGuruGranthSahibInfo(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: info.ragasInfo.length,
                    itemBuilder: (context, index) {
                      final e = info.ragasInfo[index];
                      return IndexTile(
                        number: '${e.ragaNo}',
                        title: e.name,
                        meta: '${e.totalParts} part${e.totalParts == 1 ? '' : 's'}',
                        onTap: () => GoRouter.of(context).pushNamed(Routing.guruGranthSahibRagaParts.name, pathParameters: {"ragaNo": e.ragaNo.toString()}),
                      );
                    },
                  ),
                )
              : state.isError(forr: Httpstates.GURU_GRANTH_SAHIB_INFO)
                  ? RetryAgain(onRetry: initGuruGranthSahibInfo, error: state.getError(forr: Httpstates.GURU_GRANTH_SAHIB_INFO)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initGuruGranthSahibInfo() {
    BlocProvider.of<GuruGranthSahibBloc>(context).add(FetchGuruGranthSahibInfo(cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
