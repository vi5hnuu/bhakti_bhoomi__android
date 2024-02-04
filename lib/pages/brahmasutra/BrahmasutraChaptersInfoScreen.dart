import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/brahmaSutra/brahma_sutra_bloc.dart';
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
          title: Text('Mahabharat'),
        ),
        body: BlocBuilder<BrahmaSutraBloc, BrahmaSutraState>(
          builder: (context, state) {
            final brahmasutraInfo = state.brahmasutraInfo;
            return brahmasutraInfo != null
                ? Column(
                    children: List.generate(
                        state.brahmasutraInfo!.totalChapters,
                        (index) =>
                            InkWell(onTap: () => GoRouter.of(context).pushNamed(Routing.brahmasutraQuatersInfo, pathParameters: {'chapterNo': '${index + 1}'}), child: Text('${index + 1} chapter'))),
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
