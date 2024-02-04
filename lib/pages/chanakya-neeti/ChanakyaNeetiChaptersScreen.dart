import 'package:bhakti_bhoomi/routing/routes.dart';
import 'package:bhakti_bhoomi/state/chanakyaNeeti/chanakya_neeti_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
            title: Text(
              'Chanakya Neeti',
              style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 24, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: chaptersInfo != null
              ? SingleChildScrollView(
                  child: Column(
                    children: chaptersInfo
                        .map((chapterInfo) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                              child: ListTile(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                tileColor: Theme.of(context).primaryColor,
                                leading: const Icon(Icons.menu_rounded, color: Colors.white),
                                title: Text('Chapter ${chapterInfo.chapterNo}', style: const TextStyle(fontSize: 24, color: Colors.white)),
                                subtitle: Text('Contains ${chapterInfo.versesCount} Verses', style: TextStyle(color: Colors.white)),
                                onTap: () => GoRouter.of(context).pushNamed(Routing.chanakyaNitiChapterShlok, pathParameters: {'chapterNo': '${chapterInfo.chapterNo}'}),
                              ),
                            ))
                        .toList(),
                  ),
                )
              : state.error != null
                  ? Center(child: Text(state.error!))
                  : Center(
                      child: SpinKitThreeBounce(
                      color: Theme.of(context).primaryColor,
                    )),
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
