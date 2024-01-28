import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
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
    BlocProvider.of<MantraBloc>(context).add(FetchAllMantraInfo(cancelToken: token));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MantraBloc, MantraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final mantraInfo = state.allMantraInfo;
        return Scaffold(
            appBar: AppBar(
              title: Text('Mantra'),
            ),
            body: mantraInfo != null
                ? Column(
                    children: mantraInfo.entries
                        .map((e) => InkWell(
                              onTap: () => GoRouter.of(context).pushNamed(Routing.mantra, pathParameters: {'mantraId': e.key}),
                              child: Text(e.value.title),
                            ))
                        .toList(),
                  )
                : state.error != null
                    ? Center(child: Text(state.error!))
                    : Center(child: CircularProgressIndicator()));
      },
    );
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
