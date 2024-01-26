import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/chanakyaNeeti/chanakya_neeti_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChanakyaNeetiChaptersScreen extends StatefulWidget {
  final String title;
  const ChanakyaNeetiChaptersScreen({super.key, required this.title});

  @override
  State<ChanakyaNeetiChaptersScreen> createState() => _ChanakyaNeetiChaptersScreenState();
}

class _ChanakyaNeetiChaptersScreenState extends State<ChanakyaNeetiChaptersScreen> {
  final CancelToken token = CancelToken();

  @override
  void initState() {
    BlocProvider.of<ChanakyaNeetiBloc>(context).add(FetchChanakyaNeetiChaptersInfo(cancelToken: token));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChanakyaNeetiBloc, ChanakyaNeetiState>(
      buildWhen: (previous, current) => previous.allChaptersInfo != current.allChaptersInfo,
      builder: (context, state) {
        final chaptersInfo = state.allChaptersInfo;
        return Scaffold(
          appBar: AppBar(
            title: Text('Chanakya Neeti'),
          ),
          body: ((state.isLoading || chaptersInfo == null) && state.error == null)
              ? const RefreshProgressIndicator()
              : state.error != null
                  ? Text(state.error!)
                  : SingleChildScrollView(
                      child: Column(
                        children: chaptersInfo!
                            .map((chapterInfo) => InkWell(
                                onTap: () => GoRouter.of(context).pushNamed(Routing.chanakyaNitiChapterShlok, pathParameters: {'chapterNo': '${chapterInfo.chapterNo}'}),
                                child: Container(
                                  height: 20,
                                  child: Text("${chapterInfo.chapterNo} - ${chapterInfo.versesCount}"),
                                )))
                            .toList(),
                      ),
                    ),
        );
      },
    );
  }

  @override
  void dispose() {
    token.cancel("cancelled");
    super.dispose();
  }
}
