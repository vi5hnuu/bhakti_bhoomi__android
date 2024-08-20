import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:bhakti_bhoomi/state/guruGranthSahib/guru_granth_sahib_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class GuruGranthSahibInfoScreen extends StatefulWidget {
  final String title;

  const GuruGranthSahibInfoScreen({super.key, required this.title});

  @override
  State<GuruGranthSahibInfoScreen> createState() =>
      _BhagvadGeetaChaptersScreenState();
}

class _BhagvadGeetaChaptersScreenState
    extends State<GuruGranthSahibInfoScreen> {
  final CancelToken cancelToken = CancelToken();

  @override
  void initState() {
    initGuruGranthSahibInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuruGranthSahibBloc, GuruGranthSahibState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: const Text('Guru Granth Sahib',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Kalam",
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: state.getInfo() != null
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: state.getInfo()!.ragasInfo
                        .map((e) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: RoundedListTile(
                                itemNo: e.ragaNo,
                                text: "(${e.totalParts} part/s) ${e.name}",
                                onTap: () => {
                                  GoRouter.of(context).pushNamed(Routing.guruGranthSahibRagaParts.name,pathParameters: {"ragaNo":e.ragaNo.toString()})
                                }
                              ),
                            ))
                        .toList(),
                  ),
                ),
              )
            : state.isError(forr: Httpstates.GURU_GRANTH_SAHIB_INFO)
                ? Center(
                    child: RetryAgain(
                        onRetry: initGuruGranthSahibInfo,
                        error: state.getError(
                            forr: Httpstates.GURU_GRANTH_SAHIB_INFO)!.message))
                : Center(
                    child: SpinKitThreeBounce(
                        color: Theme.of(context).primaryColor)),
      ),
    );
  }

  initGuruGranthSahibInfo() {
    BlocProvider.of<GuruGranthSahibBloc>(context)
        .add(FetchGuruGranthSahibInfo(cancelToken: cancelToken));
  }

  @override
  void dispose() {
    cancelToken.cancel("cancelled");
    super.dispose();
  }
}
