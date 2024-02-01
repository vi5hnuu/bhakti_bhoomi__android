import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/ramayan/ramayan_bloc.dart';
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
    BlocProvider.of<RamayanBloc>(context).add(FetchRamayanInfo(cancelToken: token));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RamayanBloc, RamayanState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final ramayanInfo = state.ramayanInfo;
        return Scaffold(
          appBar: AppBar(
            title: Text('Valmiki Ramayan'),
          ),
          body: Center(
            child: ramayanInfo != null
                ? ListView(
                    children: state
                        .kandas()!
                        .map((e) => InkWell(
                              onTap: () => GoRouter.of(context).pushNamed(Routing.valmikiRamayanSargasInfo, pathParameters: {'kand': e.key}),
                              child: Text('${e.value} ${e.key}'),
                            ))
                        .toList())
                : state.error != null
                    ? Text(state.error!)
                    : const CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    token.cancel();
    super.dispose();
  }
}
