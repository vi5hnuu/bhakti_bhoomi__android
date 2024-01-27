import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/rigveda/rigveda_bloc.dart';
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
    BlocProvider.of<RigvedaBloc>(context).add(FetchRigvedaInfo(cancelToken: cancelToken));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RigvedaBloc, RigvedaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Rigveda'),
          ),
          body: (state.isLoading || state.rigvedaInfo == null) && state.error == null
              ? RefreshProgressIndicator()
              : state.error != null
                  ? Text(state.error!)
                  : Column(
                      children: List.generate(
                          state.rigvedaInfo!.totalMandala,
                          (index) =>
                              InkWell(onTap: () => GoRouter.of(context).pushNamed(Routing.rigvedaMandalaSuktas, pathParameters: {'mandala': '${index + 1}'}), child: Text("${index + 1} mandala"))),
                    ),
        );
      },
    );
  }

  @override
  void dispose() {
    cancelToken.cancel();
    super.dispose();
  }
}
