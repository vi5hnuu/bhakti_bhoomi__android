import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/yogaSutra/yoga_sutra_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class YogaSutraChapters extends StatefulWidget {
  final String title;
  const YogaSutraChapters({super.key, required this.title});

  @override
  State<YogaSutraChapters> createState() => _YogaSutraChaptersState();
}

class _YogaSutraChaptersState extends State<YogaSutraChapters> {
  final CancelToken token = CancelToken();

  @override
  void initState() {
    BlocProvider.of<YogaSutraBloc>(context).add(FetchYogasutraInfo(cancelToken: token));
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
            title: Text('YogaSutra'),
          ),
          body: (state.isLoading || yogaSutraInfo == null) && state.error == null
              ? RefreshProgressIndicator()
              : state.error != null
                  ? Text(state.error!)
                  : Column(
                      children: List.generate(
                          yogaSutraInfo!.totalSutra.length,
                          (index) => InkWell(
                                onTap: () => GoRouter.of(context).pushNamed(Routing.yogaSutra, pathParameters: {'chapterNo': '${index + 1}'}),
                                child: Text("${index + 1} chapter"),
                              )),
                    ),
        );
      },
    );
  }
}
