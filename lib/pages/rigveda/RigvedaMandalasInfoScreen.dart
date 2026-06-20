import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/rigveda/rigveda_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/common/app_loader.dart';
import 'package:bhakti_bhoomi/widgets/common/app_scaffold.dart';
import 'package:bhakti_bhoomi/widgets/common/index_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RigvedaMandalasInfoScreen extends StatefulWidget {
  final String title;
  const RigvedaMandalasInfoScreen({super.key, required this.title});

  @override
  State<RigvedaMandalasInfoScreen> createState() => _RigvedaMandalasInfoScreenState();
}

class _RigvedaMandalasInfoScreenState extends State<RigvedaMandalasInfoScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    initRigvedaInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RigvedaBloc, RigvedaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final info = state.rigvedaInfo;
        return AppScaffold(
          title: 'Rig Veda',
          subtitle: 'ऋग्वेद · मण्डल',
          body: info != null
              ? RefreshIndicator(
                  onRefresh: () async => initRigvedaInfo(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: info.totalMandala,
                    itemBuilder: (context, index) => IndexTile(
                      number: '${index + 1}',
                      title: 'Mandala ${index + 1}',
                      subtitle: 'मण्डल ${index + 1}',
                      onTap: () => GoRouter.of(context).pushNamed(Routing.rigvedaMandalaSuktas.name, pathParameters: {'mandala': '${index + 1}'}),
                    ),
                  ),
                )
              : state.isError(forr: Httpstates.RIGVEDA_INFO)
                  ? RetryAgain(onRetry: initRigvedaInfo, error: state.getError(forr: Httpstates.RIGVEDA_INFO)!.message)
                  : const AppLoader(),
        );
      },
    );
  }

  initRigvedaInfo() {
    BlocProvider.of<RigvedaBloc>(context).add(FetchRigvedaInfo(cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
