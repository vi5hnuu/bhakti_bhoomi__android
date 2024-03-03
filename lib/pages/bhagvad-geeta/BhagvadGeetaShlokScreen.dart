import 'package:bhakti_bhoomi/state/bhagvadGeeta/bhagvad_geeta_bloc.dart';
import 'package:bhakti_bhoomi/widgets/EngageActions.dart';
import 'package:bhakti_bhoomi/widgets/comment/showCommentModelBottomSheet.dart';
import 'package:bhakti_bhoomi/widgets/notificationSnackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BhagvadGeetaShlokScreen extends StatefulWidget {
  final String title;
  final int chapterNo;
  const BhagvadGeetaShlokScreen({super.key, required this.title, required this.chapterNo});

  @override
  State<BhagvadGeetaShlokScreen> createState() => _BhagvadGeetaShlokScreenState();
}

class _BhagvadGeetaShlokScreenState extends State<BhagvadGeetaShlokScreen> {
  final pageStorageKey = const PageStorageKey('bhagvadGeeta_shlok_screen');
  final PageController _controller = PageController(initialPage: 0);
  CancelToken? token;

  @override
  initState() {
    token = _loadShlok(chapterNo: widget.chapterNo, shlokNo: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhagvadGeetaBloc, BhagvadGeetaState>(
      builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text('Bhagvad Geeta | Chapter No - ${widget.chapterNo}', style: TextStyle(color: Colors.white, fontFamily: "Kalam", fontSize: 18, fontWeight: FontWeight.bold)),
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: PageView.builder(
            key: pageStorageKey,
            pageSnapping: true,
            controller: _controller,
            physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
            scrollDirection: Axis.vertical,
            itemCount: state.bhagvadGeetaChapters![widget.chapterNo].versesCount,
            itemBuilder: (context, index) {
              final shlok = state.getShlok(chapterNo: widget.chapterNo, shlokNo: index + 1);
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
                              child: Column(
                                children: [
                                  IconButton(onPressed: () => this._showNotImplementedMessage(), icon: Icon(Icons.favorite_border, size: 36)),
                                  SizedBox(height: 10),
                                  IconButton(onPressed: () => this._showNotImplementedMessage(), icon: Icon(Icons.mode_comment_outlined, size: 36)),
                                  SizedBox(height: 10),
                                  IconButton(onPressed: () => this._showNotImplementedMessage(), icon: Icon(Icons.bookmark_border, size: 36)),
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: 45,
                                right: 15,
                                child: EngageActions(
                                  onBookmark: () => {},
                                  onLike: () => {},
                                  onComment: () => onComment(context: context, commentFormId: BhagvadGeetaState.commentForId(chapterNo: widget.chapterNo, shlokNo: index + 1)),
                                )),
                          ],
                        )
                      : state.error != null
                          ? Center(child: Text(state.error!))
                          : const Center(child: CircularProgressIndicator()),
                ),
              );
            },
            dragStartBehavior: DragStartBehavior.down,
            onPageChanged: (pageNo) => setState(
              () {
                token?.cancel("cancelled");
                token = _loadShlok(chapterNo: widget.chapterNo, shlokNo: pageNo + 1);
              },
            ),
          )),
    );
  }

  CancelToken _loadShlok({required int chapterNo, required int shlokNo}) {
    CancelToken cancelToken = CancelToken();
    BlocProvider.of<BhagvadGeetaBloc>(context).add(FetchBhagvadShlokByChapterNoShlokNo(chapterNo: chapterNo, shlokNo: shlokNo, cancelToken: cancelToken));
    return cancelToken;
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
