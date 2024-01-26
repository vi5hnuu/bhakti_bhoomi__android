import 'package:bhakti_bhoomi/state/chanakyaNeeti/chanakya_neeti_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChanakyaNeetiShlokScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  const ChanakyaNeetiShlokScreen({super.key, required this.title, required this.chapterNo});

  @override
  State<ChanakyaNeetiShlokScreen> createState() => _ChanakyaNeetiShlokScreenState();
}

class _ChanakyaNeetiShlokScreenState extends State<ChanakyaNeetiShlokScreen> {
  final pageStorageKey = const PageStorageKey('bhagvadGeeta_shlok_screen');
  final PageController _controller = PageController(initialPage: 0);
  CancelToken? token;

  @override
  initState() {
    super.initState();
    token = loadVerse(chapterNo: widget.chapterNo, verseNo: 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChanakyaNeetiBloc, ChanakyaNeetiState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Bhagvad Geeta'),
          ),
          body: PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: state.allChaptersInfo![widget.chapterNo].versesCount,
            itemBuilder: (context, index) {
              final verse = state.getVerse(chapterNo: widget.chapterNo, verseNo: index + 1);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ((state.isLoading || verse == null) && state.error == null)
                      ? const RefreshProgressIndicator()
                      : state.error != null
                          ? Text(state.error!)
                          : Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [Text(verse!.id)],
                                ),
                                const Positioned(
                                  bottom: 45,
                                  right: 15,
                                  child: Column(
                                    children: [
                                      IconButton(onPressed: null, icon: Icon(Icons.favorite_border, size: 36)),
                                      SizedBox(height: 10),
                                      IconButton(onPressed: null, icon: Icon(Icons.mode_comment_outlined, size: 36)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(
              () {
                print("token $token");
                token?.cancel("cancelled");
                token = loadVerse(chapterNo: widget.chapterNo, verseNo: pageNo + 1);
              },
            ),
          )),
    );
  }

  CancelToken loadVerse({required int chapterNo, required int verseNo}) {
    CancelToken cancelToken = CancelToken();
    BlocProvider.of<ChanakyaNeetiBloc>(context).add(FetchChanakyaNeetiVerseByChapterNoVerseNo(chapterNo: chapterNo, verseNo: verseNo, cancelToken: cancelToken));
    return cancelToken;
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
