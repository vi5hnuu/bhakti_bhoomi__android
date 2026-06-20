import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ValmikiRamayanKandsScreen extends StatefulWidget {
  final String title;
  const ValmikiRamayanKandsScreen({super.key, required this.title});

  @override
  State<ValmikiRamayanKandsScreen> createState() => _ValmikiRamayanKandsScreenState();
}

class _ValmikiRamayanKandsScreenState extends State<ValmikiRamayanKandsScreen> {
  final CancelToken token = CancelToken();

  @override
  void initState() {
    initRamayanaInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamayanBloc, RamayanState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final ramayanInfo = state.ramayanInfo;
        return AppScaffold(
          title: 'Valmiki Ramayan',
          subtitle: 'वाल्मीकि रामायण · ७ काण्ड',
          body: ramayanInfo != null
              ? RefreshIndicator(
                  onRefresh: () async => initRamayanaInfo(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: state
                        .kandas()!
                        .map((e) => IndexTile(
                              number: '${e.value}',
                              title: '${e.key}',
                              subtitle: 'काण्ड',
                              onTap: () => GoRouter.of(context).pushNamed(Routing.valmikiRamayanSargasInfo.name, pathParameters: {'kand': e.key}),
                            ))
                        .toList(),
                  ),
                )
              : state.isError(forr: Httpstates.RAMAYANA_INFO)
                  ? RetryAgain(onRetry: initRamayanaInfo, error: state.getError(forr: Httpstates.RAMAYANA_INFO)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initRamayanaInfo() {
    BlocProvider.of<RamayanBloc>(context).add(FetchRamayanInfo(cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel();
    super.dispose();
  }
}
