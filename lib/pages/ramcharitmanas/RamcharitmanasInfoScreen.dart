import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/ramcharitmanas/ramcharitmanas_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:bhakti_bhoomi/widgets/common/section_label.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RamcharitmanasInfoScreen extends StatefulWidget {
  final String title;
  const RamcharitmanasInfoScreen({super.key, required this.title});

  @override
  State<RamcharitmanasInfoScreen> createState() => _RamcharitmanasInfoScreenState();
}

class _RamcharitmanasInfoScreenState extends State<RamcharitmanasInfoScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    initRamcharitmanasInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamcharitmanasBloc, RamcharitmanasState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final info = state.info;
        return AppScaffold(
          title: 'Ramcharitmanas',
          subtitle: 'रामचरितमानस · ७ काण्ड',
          body: info != null
              ? RefreshIndicator(
                  onRefresh: () async => initRamcharitmanasInfo(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 8, 20, 10),
                        child: SectionLabel('KANDS · काण्ड'),
                      ),
                      for (int i = 0; i < state.getAllKands().length; i++)
                        IndexTile(
                          number: '${i + 1}',
                          title: state.getAllKands()[i],
                          subtitle: 'काण्ड',
                          onTap: () => GoRouter.of(context).pushNamed(Routing.ramcharitmanasKandVerses.name, pathParameters: {"kand": state.getAllKands()[i]}),
                        ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 20, 10),
                        child: SectionLabel('MANGALACHARAN · मंगलाचरण'),
                      ),
                      for (int i = 0; i < state.getAllKands().length; i++)
                        IndexTile(
                          number: '${i + 1}',
                          title: '${state.getAllKands()[i]} Mangalacharan',
                          subtitle: 'मंगलाचरण',
                          onTap: () => GoRouter.of(context).pushNamed(Routing.ramcharitmanasMangalaCharan.name, pathParameters: {"kand": state.getAllKands()[i]}),
                        ),
                    ],
                  ),
                )
              : state.isError(forr: Httpstates.RAMCHARITMANAS_INFO)
                  ? RetryAgain(onRetry: initRamcharitmanasInfo, error: state.getError(forr: Httpstates.RAMCHARITMANAS_INFO)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initRamcharitmanasInfo() {
    BlocProvider.of<RamcharitmanasBloc>(context).add(FetchRamcharitmanasInfo(cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
