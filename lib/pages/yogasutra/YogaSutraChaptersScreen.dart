import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/state/yogaSutra/yoga_sutra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class YogaSutraChaptersScreen extends StatefulWidget {
  final String title;
  const YogaSutraChaptersScreen({super.key, required this.title});

  @override
  State<YogaSutraChaptersScreen> createState() => _YogaSutraChaptersScreenState();
}

class _YogaSutraChaptersScreenState extends State<YogaSutraChaptersScreen> {
  final CancelToken token = CancelToken();

  @override
  void initState() {
    initYogaSutraInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YogaSutraBloc, YogaSutraState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        final yogaSutraInfo = state.yogaSutraInfo;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'YogaSutra',
              style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 32, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: yogaSutraInfo != null
              ? Column(
                  children: List.generate(
                      yogaSutraInfo.totalSutra.length,
                      (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                            child: RoundedListTile(
                              itemNo: index + 1,
                              onTap: () => GoRouter.of(context).pushNamed(Routing.yogaSutra.name, pathParameters: {'chapterNo': '${index + 1}'}),
                              text: "chapter",
                            ),
                          )),
                )
              : state.isError(forr: Httpstates.YOGASUTRA_INFO)
                  ? Center(
                      child: RetryAgain(onRetry: initYogaSutraInfo,error: state.getError(forr: Httpstates.YOGASUTRA_INFO)!.message),
                    )
                  : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor)),
        );
      },
    );
  }

  initYogaSutraInfo(){
    BlocProvider.of<YogaSutraBloc>(context).add(FetchYogasutraInfo(cancelToken: token));
  }
}
