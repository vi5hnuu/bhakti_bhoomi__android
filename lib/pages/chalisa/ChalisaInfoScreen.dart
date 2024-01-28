import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/chalisa/chalisa_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChalisaInfoScreen extends StatefulWidget {
  final String title;
  const ChalisaInfoScreen({super.key, required this.title});

  @override
  State<ChalisaInfoScreen> createState() => _ChalisaInfoScreenState();
}

class _ChalisaInfoScreenState extends State<ChalisaInfoScreen> {
  final CancelToken token = CancelToken();

  @override
  void initState() {
    BlocProvider.of<ChalisaBloc>(context).add(FetchAllChalisaInfo(cancelToken: token));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChalisaBloc, ChalisaState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final chalisaInfo = state.chalisaInfos;
        return Scaffold(
            appBar: AppBar(
              title: Text('Chalisa'),
            ),
            body: chalisaInfo != null
                ? ListView.builder(
                    itemCount: chalisaInfo.length,
                    itemBuilder: (context, index) {
                      final chalisa = chalisaInfo.entries.elementAt(index);
                      return InkWell(
                        onTap: () => GoRouter.of(context).pushNamed(Routing.chalisa, pathParameters: {'chalisaId': chalisa.key}),
                        child: Text(chalisa.value),
                      );
                    },
                  )
                : state.error != null
                    ? Center(child: Text(state.error!))
                    : Center(child: const RefreshProgressIndicator()));
      },
    );
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
