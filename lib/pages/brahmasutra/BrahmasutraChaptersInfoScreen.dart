import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/brahmaSutra/brahma_sutra_bloc.dart';
import 'package:bhakti_bhoomi/widgets/RoundedListTile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class BrahmasutraChaptersInfoScreen extends StatefulWidget {
  final String title;
  const BrahmasutraChaptersInfoScreen({super.key, required this.title});

  @override
  State<BrahmasutraChaptersInfoScreen> createState() => _BrahmasutraChaptersInfoScreenState();
}

class _BrahmasutraChaptersInfoScreenState extends State<BrahmasutraChaptersInfoScreen> {
  final CancelToken? cancelToken = CancelToken();

  @override
  void initState() {
    BlocProvider.of<BrahmaSutraBloc>(context).add(FetchBrahmasutraInfo(cancelToken: cancelToken));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BrahmaSutra', style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<BrahmaSutraBloc, BrahmaSutraState>(
          builder: (context, state) {
            final brahmasutraInfo = state.brahmasutraInfo;
            return brahmasutraInfo != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                    child: Column(
                      children: List.generate(
                          state.brahmasutraInfo!.totalChapters,
                          (index) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: RoundedListTile(
                                  itemNo: index + 1,
                                  text: "chapter",
                                  onTap: () => GoRouter.of(context).pushNamed(Routing.brahmasutraQuatersInfo, pathParameters: {'chapterNo': '${index + 1}'}),
                                ),
                              )),
                    ),
                  )
                : state.error != null
                    ? Center(child: Text(state.error!))
                    : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor));
          },
        ));
  }

  @override
  void dispose() {
    cancelToken!.cancel("Cancelled");
    super.dispose();
  }
}
