import 'package:bhakti_bhoomi/state/chanakyaNeeti/chanakya_neeti_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChanakyaNeetiShlokScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  const ChanakyaNeetiShlokScreen({super.key, required this.title, required this.chapterNo});

  @override
  State<ChanakyaNeetiShlokScreen> createState() => _ChanakyaNeetiShlokScreenState();
}

class _ChanakyaNeetiShlokScreenState extends State<ChanakyaNeetiShlokScreen> {
  final pageStorageKey = const PageStorageKey('chanakya-neeti_screen');
  final PageController _controller = PageController(initialPage: 0);
  CancelToken? token;
  int currentPage=0;

  @override
  initState() {
    loadCurrentVerse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChanakyaNeetiBloc, ChanakyaNeetiState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Chanakya Neeti | Chapter No - ${widget.chapterNo}', style: const TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold)),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
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
                child: verse != null
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: const EdgeInsets.all(8),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(verse.translations['en']!)],
                            ),
                            Positioned(
                                bottom: 45,
                                right: 15,
                                child: EngageActions(
                                  onBookmark: () => {},
                                  onLike: () => {},
                                  onComment: () => onComment(context: context, commentFormId: ChanakyaNeetiState.commentForId(chapterNo: widget.chapterNo, verseNo: index + 1)),
                                )),
                            Positioned(
                              top: 15,
                              right: 15,
                              child: IconButton(onPressed: () => this._showNotImplementedMessage(), icon: const Icon(Icons.report_problem_outlined, size: 24)),
                            )
                          ],
                        ),
                      )
                    : state.isError(forr: Httpstates.CHANAKYA_NEETI_VERSE_BY_CHAPTERNO_VERSENO)
                        ? Center(child: Text(state.getError(forr: Httpstates.CHANAKYA_NEETI_CHAPTERS_INFO)!))
                        : Center(child: SpinKitThreeBounce(color: Theme.of(context).primaryColor)),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
                currentPage=pageNo;
                _loadVerse(chapterNo: widget.chapterNo, verseNo: pageNo + 1);
              },
            ),
          )),
    );
  }

  void loadCurrentVerse() {
    _loadVerse(chapterNo: widget.chapterNo, verseNo: currentPage+1);
  }

  void _loadVerse({required int chapterNo, required int verseNo}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<ChanakyaNeetiBloc>(context).add(FetchChanakyaNeetiVerseByChapterNoVerseNo(chapterNo: chapterNo, verseNo: verseNo, cancelToken: token));
  }

  _showNotImplementedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(text: "Feature will available in next update...", color: Colors.orange));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }

}
