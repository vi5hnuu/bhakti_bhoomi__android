import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MantraInfoScreen extends StatefulWidget {
  final String title;
  const MantraInfoScreen({super.key, required this.title});

  @override
  State<MantraInfoScreen> createState() => _MantraInfoScreenState();
}

class _MantraInfoScreenState extends State<MantraInfoScreen> {
  final CancelToken token = CancelToken();

  @override
  void initState() {
    initAllMantraInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MantraBloc, MantraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final allMantraInfo = state.allMantraInfo;
        return AppScaffold(
          title: 'Mantra',
          subtitle: 'मंत्र संग्रह',
          body: allMantraInfo != null
              ? RefreshIndicator(
                  onRefresh: () async => initAllMantraInfo(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: allMantraInfo.length,
                    itemBuilder: (context, index) {
                      final mantraInfo = allMantraInfo.entries.toList()[index];
                      return IndexTile(
                        number: 'ॐ',
                        title: mantraInfo.value.title,
                        onTap: () => GoRouter.of(context).pushNamed(Routing.mantra.name, pathParameters: {'mantraId': mantraInfo.key}),
                      );
                    },
                  ),
                )
              : state.isError(forr: Httpstates.ALL_MANTRA_INFO)
                  ? RetryAgain(onRetry: initAllMantraInfo, error: state.getError(forr: Httpstates.ALL_MANTRA_INFO)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initAllMantraInfo() {
    BlocProvider.of<MantraBloc>(context).add(FetchAllMantraInfo(cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
