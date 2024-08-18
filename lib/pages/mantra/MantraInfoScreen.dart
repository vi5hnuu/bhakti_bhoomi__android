import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/mantra/mantra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: allMantraInfo != null
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                    itemCount: allMantraInfo.length,
                    itemBuilder: (context, index) {
                      final mantraInfo = allMantraInfo.entries.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: RoundedListTile(
                          onTap: () => GoRouter.of(context).pushNamed(Routing.mantra.name, pathParameters: {'mantraId': mantraInfo.key}),
                          itemNo: index + 1,
                          text: mantraInfo.value.title,
                        ),
                      );
                    })
                : state.isError(forr: Httpstates.ALL_MANTRA_INFO)
                    ? Center(child: RetryAgain(onRetry: initAllMantraInfo,error: state.getError(forr: Httpstates.ALL_MANTRA_INFO)!.message))
                    : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor)));
      },
    );
  }

  initAllMantraInfo(){
    BlocProvider.of<MantraBloc>(context).add(FetchAllMantraInfo(cancelToken: token));
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
