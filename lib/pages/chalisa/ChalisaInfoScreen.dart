import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/chalisa/chalisa_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
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
              title: Text(
                widget.title,
                style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: chalisaInfo != null
                ? ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: chalisaInfo.length,
                    itemBuilder: (context, index) {
                      final chalisa = chalisaInfo.entries.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: RoundedListTile(
                          itemNo: index + 1,
                          onTap: () => GoRouter.of(context).pushNamed(Routing.chalisa, pathParameters: {'chalisaId': chalisa.key}),
                          text: chalisa.value,
                        ),
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
