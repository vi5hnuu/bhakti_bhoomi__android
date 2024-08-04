import 'dart:ffi';

import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:bhakti_bhoomi/state/httpStates.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/RetryAgain.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BhagvadGeetaShlokScreen extends StatefulWidget {
  final String title;
  final int chapterNo;

  const BhagvadGeetaShlokScreen(
      {super.key, required this.title, required this.chapterNo});

  @override
  State<BhagvadGeetaShlokScreen> createState() =>
      _BhagvadGeetaShlokScreenState();
}

class _BhagvadGeetaShlokScreenState extends State<BhagvadGeetaShlokScreen> {
  final pageStorageKey = const PageStorageKey('bhagvadGeeta_shlok_screen');
  int currentPage = 0;
  CancelToken? token;
  final PageController _controller = PageController(initialPage: 0);

  @override
  initState() {
    reloadCurrentShlok();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhagvadGeetaBloc, BhagvadGeetaState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Bhagvad Geeta | Chapter No - ${widget.chapterNo}',
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: "Kalam",
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount:
                state.bhagvadGeetaChapters![widget.chapterNo].versesCount,
            itemBuilder: (context, index) {
              final shlok = state.getShlok(
                  chapterNo: widget.chapterNo, shlokNo: index + 1);
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: shlok != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(shlok.shlok)],
                            ),
                            Positioned(
                                bottom: 45,
                                right: 15,
                                child: EngageActions(
                                  onBookmark: () => {},
                                  onLike: () => {},
                                  onComment: () => onComment(
                                      context: context,
                                      commentFormId:
                                          BhagvadGeetaState.commentForId(
                                              chapterNo: widget.chapterNo,
                                              shlokNo: index + 1)),
                                )),
                          ],
                        )
                      : state.isError(forr: Httpstates.BHAGVAD_GEETA_SHLOK_BY_CHAPTERNO_SHLOKNO)
                          ? Center(child: RetryAgain(onRetry: reloadCurrentShlok, error: state.getError(forr: Httpstates.BHAGVAD_GEETA_SHLOK_BY_CHAPTERNO_SHLOKNO)!))
                          : const Center(child: CircularProgressIndicator()),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(() {
              currentPage = pageNo;
              _loadShlok(chapterNo: widget.chapterNo, shlokNo: pageNo+1);
            }),
          )),
    );
  }

  reloadCurrentShlok() {
    _loadShlok(chapterNo: widget.chapterNo, shlokNo: currentPage+1);
  }

  void _loadShlok({required int chapterNo, required int shlokNo}) {
    token?.cancel("cancelled");
    token = CancelToken();
    BlocProvider.of<BhagvadGeetaBloc>(context).add(
        FetchBhagvadShlokByChapterNoShlokNo(
            chapterNo: chapterNo, shlokNo: shlokNo, cancelToken: token));
  }

  _showNotImplementedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(notificationSnackbar(
        text: "Feature will available in next update...",
        color: Colors.orange));
  }

  @override
  void dispose() {
    _controller.dispose();
    token?.cancel("cancelled");
    super.dispose();
  }
}
